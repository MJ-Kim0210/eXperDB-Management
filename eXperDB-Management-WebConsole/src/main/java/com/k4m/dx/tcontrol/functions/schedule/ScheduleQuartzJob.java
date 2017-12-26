package com.k4m.dx.tcontrol.functions.schedule;

import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Calendar;
import java.util.List;
import java.util.Map;

import org.quartz.Job;
import org.quartz.JobDataMap;
import org.quartz.JobExecutionContext;
import org.quartz.JobExecutionException;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.config.AutowireCapableBeanFactory;
import org.springframework.context.ConfigurableApplicationContext;
import org.springframework.context.support.ClassPathXmlApplicationContext;

import com.k4m.dx.tcontrol.admin.dbserverManager.service.DbServerVO;
import com.k4m.dx.tcontrol.cmmn.client.ClientInfoCmmn;
import com.k4m.dx.tcontrol.common.service.AgentInfoVO;
import com.k4m.dx.tcontrol.common.service.CmmnServerInfoService;
import com.k4m.dx.tcontrol.functions.schedule.service.ScheduleService;

public class ScheduleQuartzJob implements Job{

	@Autowired
	private CmmnServerInfoService cmmnServerInfoService;
	
	private ConfigurableApplicationContext context;
	
	
	ArrayList<String> BCK_NM = new ArrayList<String>();
	
	/**
	 * 1. 스케줄ID를 가져옴
	 * 2. DBMS정보 조회(Master, Slave)
	 * 3. 해당 스케줄ID에 해당하는 스케줄 상세정보 조회(work 정보)
	 * 4. 디비서버_ID 추출하여 접속정보 조회
	 * 5. 부가옵션 조회
	 * 6. 오브젝트 옵션
	 */
	@Override
	public void execute(JobExecutionContext jobContext) throws JobExecutionException {

		 System.out.println(">>>>>>>>>>>>>>>> Schedule Start >>>>>>>>>>>>>");

			if(context != null && context.isActive())
			{	
				context.close();
			}
			
		try{
			
			List<Map<String, Object>> resultWork = null;		
			List<Map<String, Object>> resultDbconn = null;
			List<Map<String, Object>> addOption = null;
			List<Map<String, Object>> addObject = null;
			
			JobDataMap dataMap = jobContext.getJobDetail().getJobDataMap();
			
			// 1. 스케줄ID를 가져옴
			String scd_id= dataMap.getString("scd_id");
			
			System.out.println("스케줄작업명 : " +jobContext.getJobDetail().getKey().getName());
			System.out.println("스케줄ID : " +scd_id);
			
			String xml[] = {
					"egovframework/spring/context-aspect.xml",
					"egovframework/spring/context-common.xml",
					"egovframework/spring/context-datasource.xml",
					"egovframework/spring/context-mapper.xml",
					"egovframework/spring/context-properties.xml",
					"egovframework/spring/context-transaction.xml"};
			
			context = new ClassPathXmlApplicationContext(xml);
			context.getAutowireCapableBeanFactory().autowireBeanProperties(this,
					AutowireCapableBeanFactory.AUTOWIRE_BY_TYPE, false);
			
			ScheduleService scheduleService = (ScheduleService) context.getBean("scheduleService");			
		
			// 2. scd_id에 대한 (Master,Slave)DB접속 정보 가지고옴
			resultDbconn= scheduleService.selectDbconn(Integer.parseInt(scd_id));
						
			// 3. 해당 스케줄ID에 해당하는 스케줄 상세정보 조회(work 정보)
			resultWork= scheduleService.selectExeScheduleList(scd_id);
		
			Calendar calendar = Calendar.getInstance();				
	        java.util.Date date = calendar.getTime();
	        String today = (new SimpleDateFormat("yyyyMMddHHmmss").format(date));
	        
	        String bck_fileNm ="";
		       
	        
	        //마스터,슬레이브 DB갯수만큼 루프
	        for(int h=0; h<resultDbconn.size(); h++){
	        	ArrayList<String> CMD = new ArrayList<String>();
		        //WORK 갯수만큼 루프
				for(int i =0; i<resultWork.size(); i++){
			        
			        bck_fileNm = "eXperDB_"+resultWork.get(i).get("wrk_id")+"_"+today+".dump";			
					int wrk_id = Integer.parseInt(resultWork.get(i).get("wrk_id").toString());
												
					//부가옵션 조회
					addOption= scheduleService.selectAddOption(wrk_id);
					
					//오브젝트옵션 조회
					addObject= scheduleService.selectAddObject(wrk_id);
											
					// 백업 내용이 DUMP 백업일경우 
					if(resultWork.get(i).get("bck_bsn_dscd").equals("TC000202")){
						String strCmd ="";
						strCmd = dumpBackupMakeCmd(resultDbconn, resultWork, addOption, addObject, i, bck_fileNm, h);	
						BCK_NM.add(bck_fileNm);
						CMD.add(strCmd);
					// 백업 내용이 RMAN 백업일경우	
					}else{
						String rmanCmd ="";
						rmanCmd = rmanBackupMakeCmd(resultWork, i, resultDbconn, h);		
						CMD.add(rmanCmd);
					}
				}		
				System.out.println("명령어="+CMD);
				agentCall(resultWork, CMD, BCK_NM, resultDbconn, h);
	        }
		}catch(Exception e){
			e.printStackTrace();
		}

	}


	/**
	 * 1. Connection Option 명령어 생성
	 * 2. 기본옵션 명령어 생성
	 * 3. 부가옵션 명령어 생성  
	 * 4. 오브젝트옵션 명령어 생성
	 * @param addObject 
	 * @param i 
	 * @param h 
	 * @param resultDbconn2 
	 * @param result
	 * @return
	 */
	@SuppressWarnings("unused")
	private String dumpBackupMakeCmd(List<Map<String, Object>> resultDbconn, List<Map<String, Object>> resultWork, List<Map<String, Object>> addOption, List<Map<String, Object>> addObject, int i, String bck_fileNm, int h) {

		String strCmd = "pg_dump ";
		String strLast = "";
		
		try {		
			//DBMS정보 추출
			String DBMS = fn_dbmsInfo(resultDbconn, h);
			strCmd += DBMS;
			
			//기본옵션 명령어 생성	
			String basicCmd = fn_basicOption(resultWork, i, bck_fileNm);
			strCmd +=basicCmd;
						
			//부가옵션 명령어 생성
			String addCmd = fn_addOption(addOption);	
			strCmd += addCmd;
					
			//오브젝트옵션 명령어 생성
			if(addObject.size() != 0){
				String objCmd = fn_objOption(addObject);	
				strCmd += objCmd;
			}					
			strCmd += " "+resultWork.get(i).get("db_nm")+"  > "+resultWork.get(i).get("save_pth")+"/"+bck_fileNm;
		} catch (Exception e) {			
			e.printStackTrace();
		}		
		return strCmd;
	}


	private String fn_dbmsInfo(List<Map<String, Object>> resultDbconn, int h) {
		String DBMS = "";
		//1.1 연결할 데이터베이스의 이름 지정
		//DBMS += "--dbname="+resultDbconn.get(h).get("dft_db_nm");
		//1.2 호스트 이름 지정
		DBMS += " --host="+resultDbconn.get(h).get("ipadr");
		//1.3 서버가 연결을 청취하는 TCP포트 설정
		DBMS += " --port="+resultDbconn.get(h).get("portno");
		//1.4 연결할 사용자이름
		DBMS += " --username="+resultDbconn.get(h).get("svr_spr_usr_id");	
		DBMS += " --no-password";	
		return DBMS;
	}

	private String fn_basicOption(List<Map<String, Object>> resultWork, int i, String bck_fileNm) {
		String strBasic = "";

		if(resultWork.get(i).get("file_fmt_cd_nm") != null && resultWork.get(i).get("file_fmt_cd_nm") != ""){
			//파일포멧에 따른 명령어 생성
			strBasic += " --format="+resultWork.get(i).get("file_fmt_cd_nm").toString().toLowerCase();
			//파일포멧이 tar일경우 압축률 명령어 생성
			if(resultWork.get(i).get("file_fmt_cd_nm") == "tar"){
				strBasic += " --compress="+resultWork.get(i).get("cprt").toString().toLowerCase();
			}
		}
		
		//인코딩 방식 명령어 생성
		if(resultWork.get(i).get("incd") != null && resultWork.get(i).get("incd") != ""){
			strBasic +=" --encoding="+resultWork.get(i).get("incd").toString().toLowerCase();
		}		
		
		//rolename 명령어 생성		
		if(resultWork.get(i).get("incd") != null && !resultWork.get(i).get("usr_role_nm").equals("")){
			strBasic +=" --role="+resultWork.get(i).get("usr_role_nm").toString().toLowerCase();
		}		
		return strBasic;
	}
	
	private String fn_addOption(List<Map<String, Object>> addOption) {	
		String strAdd = "";
		
		for(int j =0; j<addOption.size(); j++){
			// Sections
			if(addOption.get(j).get("grp_cd").toString() != null && addOption.get(j).get("grp_cd").toString().equals("TC0006")){
				strAdd +=" --section="+addOption.get(j).get("opt_cd_nm").toString().toLowerCase();
			}
			// Object형태
			if(addOption.get(j).get("opt_cd").toString() != null && addOption.get(j).get("opt_cd").toString().equals("TC0007")){
				// Object형태(Only data)
				if(addOption.get(j).get("opt_cd").toString().equals("TC000701")){
					strAdd +=" --data-only";
				// Object형태(Only Schema)
				}else if (addOption.get(j).get("opt_cd").toString().equals("TC000702")){
					strAdd +=" --schema-only";
				// Object형태(Blobs)
				}else{
					strAdd +=" --blobs";
				}
			}
			// 저장제외항목
			if(addOption.get(j).get("grp_cd").toString() != null && addOption.get(j).get("grp_cd").toString().equals("TC0008")){
				strAdd +=" --no-"+addOption.get(j).get("opt_cd_nm").toString().toLowerCase();
			}
			// 쿼리
			if(addOption.get(j).get("grp_cd").toString() != null && addOption.get(j).get("grp_cd").toString().equals("TC0009")){
				// 쿼리(Use Column Inserts)
				if(addOption.get(j).get("opt_cd").toString().equals("TC000901")){
					strAdd +=" --column-insert";
				// 쿼리(Use Insert Commands)
				}else if (addOption.get(j).get("opt_cd").toString().equals("TC000902")){
					strAdd +=" --attribute-inserts";
				// 쿼리(Include CREATE DATABASE statement)
				}else if(addOption.get(j).get("opt_cd").toString().equals("TC000903")){
					strAdd +=" --create";
				// 쿼리(Include DROP DATABASE statement)
				}else{
					strAdd +=" --clean";
				}
			}
			// Miscellaneous
			if(addOption.get(j).get("grp_cd").toString() != null && addOption.get(j).get("grp_cd").toString().equals("TC0010")){
				// Miscellaneous(With OID(s))
				if(addOption.get(j).get("opt_cd").toString().equals("TC001001")){
					strAdd +=" --oids";
				// Miscellaneous(Verbose messages)
				}else if (addOption.get(j).get("opt_cd").toString().equals("TC001002")){
					strAdd +=" --verbose";
				// Miscellaneous(Force double quote on identifiers)
				}else if(addOption.get(j).get("opt_cd").toString().equals("TC001003")){
					strAdd +=" --quote-all-identifiers";
				// Miscellaneous(Use SET SESSION AUTHORIZATION)
				}else{
					strAdd +=" --use-set-session-authorization";
				}
			}
		}
		return strAdd;
	}

	private String fn_objOption(List<Map<String, Object>> addObject) {	
		String strObj = "";
		for(int n=0; n<addObject.size(); n++){			
			if(addObject.get(n).get("obj_nm").equals(null) || addObject.get(n).get("obj_nm").equals("")){
				strObj+=" -n "+addObject.get(n).get("scm_nm").toString().toLowerCase();
			}else{
				strObj+=" -t "+addObject.get(n).get("obj_nm").toString().toLowerCase();
			}
		}
		return strObj;
	}



	private String rmanBackupMakeCmd(List<Map<String, Object>> resultWork, int i, List<Map<String, Object>> resultDbconn, int h) {
		String rmanCmd = "pg_rman backup ";

		//DBMS정보 추출
		String dbmsInfo = fn_dbmsInfo(resultDbconn, h);
		rmanCmd += dbmsInfo;
		
		//데이터베이스 클러스터의 절대경로
		rmanCmd += " --pgdata="+resultWork.get(i).get("data_pth").toString();
		
		//백업 카탈로그의 절대경로
		rmanCmd += " --backup-path="+resultWork.get(i).get("bck_pth").toString();
		
		//백업모드
		if(resultWork.get(i).get("bck_opt_cd").toString().equals("TC000301")){
			rmanCmd += " --backup-mode=full";
		}else if(resultWork.get(i).get("bck_opt_cd").toString().equals("TC000302")){
			rmanCmd += " --backup-mode=incremental";
		}else{
			rmanCmd += " --backup-mode=archive";
		}
		
		rmanCmd += " -A $PGDATA/pg_xlog/archive_status/";
		
		if(resultWork.get(i).get("cps_yn").toString().equals("Y")){
			rmanCmd += " --with-serverlog";
		}
		
		if(resultWork.get(i).get("log_file_bck_yn").toString().equals("Y")){
			rmanCmd += " --compress-data";
		}
				
		rmanCmd += " --keep-data-generations="+resultWork.get(i).get("bck_mtn_ecnt");
		rmanCmd += " --keep-data-days="+resultWork.get(i).get("file_stg_dcnt");
		rmanCmd += " --keep-arclog-files="+resultWork.get(i).get("acv_file_mtncnt");
		rmanCmd += " --keep-arclog-days="+resultWork.get(i).get("acv_file_stgdt");
		rmanCmd += " --keep-srvlog-files="+resultWork.get(i).get("log_file_mtn_ecnt");
		rmanCmd += " --keep-srvlog-days="+resultWork.get(i).get("log_file_stg_dcnt");

		rmanCmd += " >> "+resultWork.get(i).get("log_file_pth")+"/"+resultWork.get(i).get("wrk_nm")+".log 2>&1";
		return rmanCmd;	
	}
	
	
	public void agentCall(List<Map<String, Object>> resultWork, ArrayList<String> CMD, ArrayList<String> BCKNM, List<Map<String, Object>> resultDbconn, int h) {
		try {
				String IP = (String) resultDbconn.get(h).get("ipadr");
				AgentInfoVO vo = new AgentInfoVO();
				vo.setIPADR(IP);			
				AgentInfoVO agentInfo =  (AgentInfoVO) cmmnServerInfoService.selectAgentInfo(vo);	
				int PORT = agentInfo.getSOCKET_PORT();
						
				ClientInfoCmmn clc = new ClientInfoCmmn();
				clc.db_backup(resultWork, CMD, IP ,PORT, BCKNM);	
		} catch (Exception e) {
			e.printStackTrace();
		}
	}
	

}
