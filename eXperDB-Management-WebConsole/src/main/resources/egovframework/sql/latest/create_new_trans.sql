INSERT INTO T_SYSGRP_C(GRP_CD, GRP_CD_NM, GRP_CD_EXP, USE_YN, FRST_REGR_ID, FRST_REG_DTM, LST_MDFR_ID, LST_MDF_DTM ) VALUES( 'TC0036', '스냅샷모드', '데이터전송 스냅샷모드', 'Y', 'ADMIN', clock_timestamp(), 'ADMIN', clock_timestamp());

INSERT INTO T_SYSDTL_C(GRP_CD, SYS_CD, SYS_CD_NM, USE_YN, FRST_REGR_ID, FRST_REG_DTM, LST_MDFR_ID, LST_MDF_DTM ) VALUES('TC0036', 'TC003601', 'INITIAL', 'Y', 'ADMIN', CLOCK_TIMESTAMP(), 'ADMIN', CLOCK_TIMESTAMP());
INSERT INTO T_SYSDTL_C(GRP_CD, SYS_CD, SYS_CD_NM, USE_YN, FRST_REGR_ID, FRST_REG_DTM, LST_MDFR_ID, LST_MDF_DTM ) VALUES('TC0036', 'TC003602', 'ALWAYS', 'N', 'ADMIN', CLOCK_TIMESTAMP(), 'ADMIN', CLOCK_TIMESTAMP());
INSERT INTO T_SYSDTL_C(GRP_CD, SYS_CD, SYS_CD_NM, USE_YN, FRST_REGR_ID, FRST_REG_DTM, LST_MDFR_ID, LST_MDF_DTM ) VALUES('TC0036', 'TC003603', 'NEVER', 'Y', 'ADMIN', CLOCK_TIMESTAMP(), 'ADMIN', CLOCK_TIMESTAMP());
INSERT INTO T_SYSDTL_C(GRP_CD, SYS_CD, SYS_CD_NM, USE_YN, FRST_REGR_ID, FRST_REG_DTM, LST_MDFR_ID, LST_MDF_DTM ) VALUES('TC0036', 'TC003604', 'INITIAL_ONLY', 'N', 'ADMIN', CLOCK_TIMESTAMP(), 'ADMIN', CLOCK_TIMESTAMP());
INSERT INTO T_SYSDTL_C(GRP_CD, SYS_CD, SYS_CD_NM, USE_YN, FRST_REGR_ID, FRST_REG_DTM, LST_MDFR_ID, LST_MDF_DTM ) VALUES('TC0036', 'TC003605', 'EXPORTED', 'N', 'ADMIN', CLOCK_TIMESTAMP(), 'ADMIN', CLOCK_TIMESTAMP());



CREATE TABLE T_TRANS_EXRTEXCT_MAPP (
	TRANS_EXRT_EXCT_TB_ID NUMERIC NOT NULL,
	EXRT_EXCT_TB_NM TEXT NULL,
	EXRT_EXCT_SCM_NM TEXT NULL,
	SCHEMA_TOTAL_CNT NUMERIC NULL,
	TABLE_TOTAL_CNT NUMERIC NULL,
	FRST_REGR_ID VARCHAR(30) NULL,
	FRST_REG_DTM TIMESTAMP NOT NULL,
	CONSTRAINT PK_T_TRANS_EXRTEXCT_MAPP PRIMARY KEY (TRANS_EXRT_EXCT_TB_ID)
);


COMMENT ON TABLE T_TRANS_EXRTEXCT_MAPP IS '전송제외테이블';

 COMMENT ON COLUMN T_TRANS_EXRTEXCT_MAPP.TRANS_EXRT_EXCT_TB_ID IS '전송제외아이디';
 COMMENT ON COLUMN T_TRANS_EXRTEXCT_MAPP.EXRT_EXCT_TB_NM IS '전송제외테이블명';
 COMMENT ON COLUMN T_TRANS_EXRTEXCT_MAPP.EXRT_EXCT_SCM_NM IS '전송제외스키마명';
 COMMENT ON COLUMN T_TRANS_EXRTEXCT_MAPP.SCHEMA_TOTAL_CNT IS '전송제외스키마수';
 COMMENT ON COLUMN T_TRANS_EXRTEXCT_MAPP.TABLE_TOTAL_CNT IS '전송제외테이블수';
 COMMENT ON COLUMN T_TRANS_EXRTEXCT_MAPP.FRST_REGR_ID IS '최초_등록자_ID';
 COMMENT ON COLUMN T_TRANS_EXRTEXCT_MAPP.FRST_REG_DTM IS '최초_등록_일시';


CREATE SEQUENCE Q_T_TRANS_EXRTEXCT_MAPP_01;


CREATE TABLE T_TRANS_EXRTTRG_MAPP (
	TRANS_EXRT_TRG_TB_ID NUMERIC NOT NULL,
	EXRT_TRG_TB_NM TEXT NULL,
	EXRT_TRG_SCM_NM TEXT NULL,
	SCHEMA_TOTAL_CNT NUMERIC NULL,
	TABLE_TOTAL_CNT NUMERIC NULL,
	FRST_REGR_ID VARCHAR(30) NULL,
	FRST_REG_DTM TIMESTAMP NOT NULL,
	CONSTRAINT PK_T_TRANS_EXRTTRG_MAPP PRIMARY KEY (TRANS_EXRT_TRG_TB_ID)
);



COMMENT ON TABLE T_TRANS_EXRTTRG_MAPP IS '전송대상테이블';

 COMMENT ON COLUMN T_TRANS_EXRTTRG_MAPP.TRANS_EXRT_TRG_TB_ID IS '전송대상아이디';
 COMMENT ON COLUMN T_TRANS_EXRTTRG_MAPP.EXRT_TRG_TB_NM IS '전송대상테이블명';
 COMMENT ON COLUMN T_TRANS_EXRTTRG_MAPP.EXRT_TRG_SCM_NM IS '전송대상스키마명';
 COMMENT ON COLUMN T_TRANS_EXRTTRG_MAPP.SCHEMA_TOTAL_CNT IS '전송대상스키마수';
 COMMENT ON COLUMN T_TRANS_EXRTTRG_MAPP.TABLE_TOTAL_CNT IS '전송대상테이블수';
 COMMENT ON COLUMN T_TRANS_EXRTTRG_MAPP.FRST_REGR_ID IS '최초_등록자_ID';
 COMMENT ON COLUMN T_TRANS_EXRTTRG_MAPP.FRST_REG_DTM IS '최초_등록_일시';


CREATE SEQUENCE Q_T_TRANS_EXRTTRG_MAPP_01;


CREATE TABLE T_TRANSCNG_I(
	TRANS_ID           NUMERIC(18) NOT NULL DEFAULT 1,
	KC_IP          VARCHAR(50) NULL,
	KC_PORT           NUMERIC(5) NOT NULL DEFAULT 0,
	CONNECT_NM           VARCHAR(50) NULL,
	SNAPSHOT_MODE         VARCHAR(50) NULL,
	DB_ID         		  NUMERIC(18) NOT NULL DEFAULT 1,
	DB_SVR_ID            NUMERIC(18) NOT NULL DEFAULT 1,	
	TRANS_EXRT_TRG_TB_ID numeric NULL,
	TRANS_EXRT_EXCT_TB_ID numeric NULL,	
	EXE_STATUS VARCHAR(20) NOT NULL DEFAULT 'TC001502',
	FRST_REGR_ID         VARCHAR(30) NULL,
	FRST_REG_DTM         TIMESTAMP NOT NULL DEFAULT CLOCK_TIMESTAMP(),
	LST_MDFR_ID          VARCHAR(30) NULL,
	LST_MDF_DTM          TIMESTAMP NOT NULL DEFAULT CLOCK_TIMESTAMP(),
	CONSTRAINT fk_T_TRANSCNG_I_01 FOREIGN KEY (TRANS_EXRT_TRG_TB_ID) REFERENCES T_TRANS_EXRTTRG_MAPP(TRANS_EXRT_TRG_TB_ID),
	CONSTRAINT fk_T_TRANSCNG_I_02 FOREIGN KEY (TRANS_EXRT_EXCT_TB_ID) REFERENCES T_TRANS_EXRTEXCT_MAPP(TRANS_EXRT_EXCT_TB_ID)
);


ALTER TABLE T_TRANSCNG_I ADD CONSTRAINT PK_T_TRANSCNG_I
PRIMARY KEY (TRANS_ID);


COMMENT ON TABLE T_TRANSCNG_I IS '전송설정테이블';

 COMMENT ON COLUMN T_TRANSCNG_I.TRANS_ID IS '전송_ID';
 COMMENT ON COLUMN T_TRANSCNG_I.KC_IP IS '커넥터_아이피';
 COMMENT ON COLUMN T_TRANSCNG_I.KC_PORT IS '커넥터_포트';
 COMMENT ON COLUMN T_TRANSCNG_I.CONNECT_NM IS '커넥트명';
 COMMENT ON COLUMN T_TRANSCNG_I.SNAPSHOT_MODE IS '스냅샷모드';
 COMMENT ON COLUMN T_TRANSCNG_I.DB_ID IS '디비_아이디';
 COMMENT ON COLUMN T_TRANSCNG_I.DB_SVR_ID IS '디비_서버_아이디';
 COMMENT ON COLUMN T_TRANSCNG_I.TRANS_EXRT_TRG_TB_ID IS '전송 포함_아이디';
 COMMENT ON COLUMN T_TRANSCNG_I.TRANS_EXRT_EXCT_TB_ID IS '전송_제외_아이디';
 COMMENT ON COLUMN T_TRANSCNG_I.FRST_REGR_ID IS '최초_등록자_ID';
 COMMENT ON COLUMN T_TRANSCNG_I.FRST_REG_DTM IS '최초_등록_일시';
 COMMENT ON COLUMN T_TRANSCNG_I.LST_MDFR_ID IS '최종_수정자_ID';
 COMMENT ON COLUMN T_TRANSCNG_I.LST_MDF_DTM IS '최종_수정_일시';

CREATE SEQUENCE Q_T_TRANSCNG_I_01;

INSERT INTO T_SYSGRP_C(GRP_CD, GRP_CD_NM, GRP_CD_EXP, USE_YN, FRST_REGR_ID, FRST_REG_DTM, LST_MDFR_ID, LST_MDF_DTM ) VALUES( 'TC0037', '압축형태', '데이터전송 압축형태', 'Y', 'ADMIN', clock_timestamp(), 'ADMIN', clock_timestamp());

INSERT INTO T_SYSDTL_C(GRP_CD, SYS_CD, SYS_CD_NM, USE_YN, FRST_REGR_ID, FRST_REG_DTM, LST_MDFR_ID, LST_MDF_DTM ) VALUES('TC0037', 'TC003701', 'NONE', 'Y', 'ADMIN', CLOCK_TIMESTAMP(), 'ADMIN', CLOCK_TIMESTAMP());
INSERT INTO T_SYSDTL_C(GRP_CD, SYS_CD, SYS_CD_NM, USE_YN, FRST_REGR_ID, FRST_REG_DTM, LST_MDFR_ID, LST_MDF_DTM ) VALUES('TC0037', 'TC003702', 'GZIP', 'Y', 'ADMIN', CLOCK_TIMESTAMP(), 'ADMIN', CLOCK_TIMESTAMP());
INSERT INTO T_SYSDTL_C(GRP_CD, SYS_CD, SYS_CD_NM, USE_YN, FRST_REGR_ID, FRST_REG_DTM, LST_MDFR_ID, LST_MDF_DTM ) VALUES('TC0037', 'TC003703', 'SNAPPY', 'Y', 'ADMIN', CLOCK_TIMESTAMP(), 'ADMIN', CLOCK_TIMESTAMP());
INSERT INTO T_SYSDTL_C(GRP_CD, SYS_CD, SYS_CD_NM, USE_YN, FRST_REGR_ID, FRST_REG_DTM, LST_MDFR_ID, LST_MDF_DTM ) VALUES('TC0037', 'TC003704', 'LZ4', 'Y', 'ADMIN', CLOCK_TIMESTAMP(), 'ADMIN', CLOCK_TIMESTAMP());
INSERT INTO T_SYSDTL_C(GRP_CD, SYS_CD, SYS_CD_NM, USE_YN, FRST_REGR_ID, FRST_REG_DTM, LST_MDFR_ID, LST_MDF_DTM ) VALUES('TC0037', 'TC003705', 'ZSTD', 'Y', 'ADMIN', CLOCK_TIMESTAMP(), 'ADMIN', CLOCK_TIMESTAMP());


ALTER TABLE T_TRANSCNG_I ADD COLUMN compression_type varchar(50);
COMMENT ON COLUMN T_TRANSCNG_I.compression_type IS '압축형태';

ALTER TABLE T_TRANSCNG_I ADD COLUMN meta_data varchar(50);
COMMENT ON COLUMN T_TRANSCNG_I.meta_data IS '메타데이터 사용유무';
