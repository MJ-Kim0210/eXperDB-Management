package com.k4m.dx.tcontrol.deamon;

import java.io.*;

/**
 * 락 파일이 이미 존재할 때 발생하는 예외
* @author 박태혁
* @see
* 
*      <pre>
* == 개정이력(Modification Information) ==
*
*   수정일       수정자           수정내용
*  -------     --------    ---------------------------
*  2018.04.23   박태혁 최초 생성
*      </pre>
*/
public class LockFileExistException extends Exception {

	String lockFilePath = null;
	
	/**
	 * 락 파일이 이미 존재할 때 발생하는 예외
	 * @@param lockFile 락 파일의 객체
	 */
	public LockFileExistException(File lockFile) {
		super(lockFile.getAbsolutePath() + " Lock 파일이 이미 존재합니다.");
		lockFilePath = lockFile.getAbsolutePath();
	}
	
	/**
	 * 락 파일의 경로를 리턴한다.
	 * @@return 락 파일 경로
	 */
	public String getLockFilePath() {
		return this.lockFilePath;
	}
}
