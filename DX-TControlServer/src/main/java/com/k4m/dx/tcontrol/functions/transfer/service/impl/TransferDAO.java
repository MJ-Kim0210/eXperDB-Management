package com.k4m.dx.tcontrol.functions.transfer.service.impl;

import java.sql.SQLException;
import java.util.List;
import java.util.Map;

import org.springframework.stereotype.Repository;

import com.k4m.dx.tcontrol.functions.transfer.service.ConnectorVO;
import com.k4m.dx.tcontrol.functions.transfer.service.TransferVO;
import com.k4m.dx.tcontrol.tree.transfer.service.TransferMappingVO;

import egovframework.rte.psl.dataaccess.EgovAbstractMapper;

@Repository("transferDAO")
public class TransferDAO extends EgovAbstractMapper {

	/**
	 * 전송설정 조회
	 * 
	 * @param usr_id
	 * @throws SQLException
	 */
	@SuppressWarnings({ "unchecked", "deprecation" })
	public List<TransferVO> selectTransferSetting(String usr_id) {
		List<TransferVO> result = null;
		result = (List<TransferVO>) list("transferSql.selectTransferSetting", usr_id);
		return result;
	}

	/**
	 * 전송설정 등록
	 * 
	 * @param transferVO
	 * @throws SQLException
	 */
	public void insertTransferSetting(TransferVO transferVO) throws SQLException {
		insert("transferSql.insertTransferSetting", transferVO);
	}

	/**
	 * 전송설정 등록
	 * 
	 * @param transferVO
	 * @throws SQLException
	 */
	public void updateTransferSetting(TransferVO transferVO) throws SQLException {
		update("transferSql.updateTransferSetting", transferVO);
	}

	/**
	 * Connector 리스트 조회
	 * 
	 * @param param
	 * @return
	 * @throws SQLException
	 */
	@SuppressWarnings({ "unchecked", "deprecation" })
	public List<ConnectorVO> selectConnectorRegister(Map<String, Object> param) throws SQLException {
		List<ConnectorVO> sl = null;
		sl = (List<ConnectorVO>) list("transferSql.selectConnectorRegister", param);
		return sl;
	}

	/**
	 * Connector 상세조회
	 * 
	 * @param cnr_id
	 * @return
	 * @throws SQLException
	 */
	@SuppressWarnings({ "unchecked", "deprecation" })
	public List<ConnectorVO> selectDetailConnectorRegister(int cnr_id) throws SQLException {
		List<ConnectorVO> sl = null;
		sl = (List<ConnectorVO>) list("transferSql.selectDetailConnectorRegister", cnr_id);
		return sl;
	}

	/**
	 * Connector 등록
	 * 
	 * @param connectorVO
	 * @throws SQLException
	 */
	public void insertConnectorRegister(ConnectorVO connectorVO) throws SQLException {
		delete("transferSql.insertConnectorRegister", connectorVO);

	}

	/**
	 * Connector 수정
	 * 
	 * @param connectorVO
	 * @throws SQLException
	 */
	public void updateConnectorRegister(ConnectorVO connectorVO) throws SQLException {
		delete("transferSql.updateConnectorRegister", connectorVO);
	}

	/**
	 * Connector 삭제
	 * 
	 * @param cnr_id
	 * @throws SQLException
	 */
	public void deleteConnectorRegister(int cnr_id) throws SQLException {
		delete("transferSql.deleteConnectorRegister", cnr_id);

	}

	/**
	 * 전송대상설정정보 삭제
	 * 
	 * @param cnr_id
	 * @throws SQLException
	 */
	public void deleteTransferInfo(int cnr_id) throws SQLException {
		delete("transferSql.deleteTransferInfo", cnr_id);

	}

	/**
	 * trf_trg_mpp_id 조회
	 * 
	 * @param cnr_id
	 * @throws SQLException
	 */
	@SuppressWarnings({ "deprecation", "unchecked" })
	public List<TransferMappingVO> selectTrftrgmppid(int cnr_id) throws SQLException {
		List<TransferMappingVO>  result = null;
		result = (List<TransferMappingVO>) list("transferSql.selectTrftrgmppid", cnr_id);
		return result;
	}

	/**
	 * 전송대상매핑관계 삭제
	 * 
	 * @param cnr_id
	 * @throws SQLException
	 */
	public void deleteTransferRelation(int cnr_id) throws SQLException {
		delete("transferSql.deleteTransferRelation", cnr_id);
	}

	/**
	 * 전송매핑테이블 삭제
	 * 
	 * @param trf_trg_mpp_id
	 * @throws SQLException
	 */
	public void deleteTransferMapping(int trf_trg_mpp_id) throws SQLException {
		delete("transferSql.deleteTransferMapping", trf_trg_mpp_id);
	}

}
