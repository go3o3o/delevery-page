-- 회원, 주문, 가게, 메뉴, 리뷰
-- 추후 생각: 쿠폰, 이벤트 
CREATE TABLE tb_member (
	seq SMALLINT UNSIGNED NOT NULL AUTO_INCREMENT COMMENT '회원 시퀀스', 
	email VARCHAR(1000) NOT NULL COMMENT '회원 이메일',
	password VARCHAR(1000) NOT NULL COMMENT '회원 비밀번호',
	phone_number VARCHAR(11) NOT NULL COMMENT '회원 전화번호', 
	nickname VARCHAR(100) NOT NULL COMMENT '회원 닉네임', 
	reg_dt DATETIME DEFAULT CURRENT_TIMESTAMP COMMENT '등록일자',
	upd_dt DATETIME ON UPDATE CURRENT_TIMESTAMP COMMENT '수정일자',
	PRIMARY KEY (seq)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='회원 테이블'; 

CREATE TABLE tb_order (
	seq SMALLINT UNSIGNED NOT NULL AUTO_INCREMENT COMMENT '주문 시퀀스', 
	order_md5 VARCHAR(50) NOT NULL COMMENT '주문번호 md5(회원 시퀀스+주문일자)',
    member_seq SMALLINT UNSIGNED NOT NULL COMMENT '회원 시퀀스',
	menu_seq SMALLINT UNSIGNED NOT NULL COMMENT '메뉴 시퀀스', 
	order_yn VARCHAR(2) DEFAULT 'N' COMMENT '배달 완료 여부', 
	reg_dt DATETIME DEFAULT CURRENT_TIMESTAMP COMMENT '주문일자',
	PRIMARY KEY (seq),
	FOREIGN KEY (member_seq) REFERENCES tb_member(seq) ON UPDATE CASCADE,
	FOREIGN KEY (menu_seq) REFERENCES tb_menu(seq) ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='주문 테이블';

CREATE TABLE tb_store ( 
	seq SMALLINT UNSIGNED NOT NULL AUTO_INCREMENT COMMENT '가게 시퀀스', 
	store_name VARCHAR(1000) NOT NULL COMMENT '가게명', 
	store_phone_number VARCHAR(1000) DEFAULT '' COMMENT '가게 전화번호', 
	store_location VARCHAR(2000) NOT NULL COMMENT '가게 위치', 
	category_seq SMALLINT UNSIGNED NOT NULL COMMENT '카테고리 분류', 
	logo_img VARCHAR(500) DEFAULT '' COMMENT '가게 로고', 
	rating VARCHAR(10) DEFAULT 0 COMMENT '별점', 
	order_count INTEGER NOT NULL DEFAULT 0 COMMENT '주문 수', 
	dib_count INTEGER NOT NULL DEFAULT 0 COMMENT '찜 수', 
	order_tip INTEGER NOT NULL DEFAULT 0 COMMENT '배달비', 
	order_time INTEGER COMMENT '배달시간', 
	order_price INTEGER NOT NULL DEFAULT 0 COMMENT '배달최소금액',
	description VARCHAR(5000) COMMENT '가게 소개',
	notice VARCHAR(5000) COMMENT '안내 및 혜택', 
	reg_dt DATETIME DEFAULT CURRENT_TIMESTAMP COMMENT '등록일자',
	upd_dt DATETIME ON UPDATE CURRENT_TIMESTAMP COMMENT '수정일자',
	PRIMARY KEY (seq),
	FOREIGN KEY (category_seq) REFERENCES tb_category(seq) ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='가게 테이블';

CREATE TABLE tb_menu (
	seq SMALLINT UNSIGNED NOT NULL AUTO_INCREMENT COMMENT '메뉴 시퀀스', 
	store_seq SMALLINT UNSIGNED NOT NULL COMMENT '가게 시퀀스',
	menu_name VARCHAR(1000) NOT NULL COMMENT '메뉴명', 
	-- menu_price INTEGER NOT NULL COMMENT '메뉴 가격',
	menu_img VARCHAR(500) COMMENT '메뉴 이미지', 
	menu_grp VARCHAR(500) DEFAULT 'N' COMMENT '메뉴 상위 그룹',
	menu_desc VARCHAR(500) COMMENT '메뉴 설명',
	reg_dt DATETIME DEFAULT CURRENT_TIMESTAMP COMMENT '등록일자',
	upd_dt DATETIME ON UPDATE CURRENT_TIMESTAMP COMMENT '수정일자',
	PRIMARY KEY (seq), 
	FOREIGN KEY (store_seq) REFERENCES tb_store(seq) ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='메뉴 테이블'; 

CREATE TABLE tb_menu_option (
	seq SMALLINT UNSIGNED NOT NULL AUTO_INCREMENT COMMENT '메뉴옵션 시퀀스',
	menu_seq SMALLINT UNSIGNED NOT NULL COMMENT '메뉴 시퀀스',
	menu_option_grp VARCHAR(500) DEFAULT '기본' COMMENT '메뉴 옵션 상위 그룹',
	menu_option VARCHAR(500) DEFAULT '' COMMENT '메뉴 옵션',
	menu_price INTEGER NOT NULL COMMENT '메뉴 가격',
	reg_dt DATETIME DEFAULT CURRENT_TIMESTAMP COMMENT '등록일자',
	upd_dt DATETIME ON UPDATE CURRENT_TIMESTAMP COMMENT '수정일자',
	PRIMARY KEY (seq),
	FOREIGN KEY (menu_seq) REFERENCES tb_menu(seq) ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='메뉴옵션 테이블';

CREATE TABLE tb_category (
	seq SMALLINT UNSIGNED NOT NULL AUTO_INCREMENT COMMENT '카테고리 시퀀스', 
	category_name VARCHAR(100) NOT NULL COMMENT '카테고리명'
	reg_dt DATETIME DEFAULT CURRENT_TIMESTAMP COMMENT '등록일자',
	upd_dt DATETIME ON UPDATE CURRENT_TIMESTAMP COMMENT '수정일자',
	PRIMARY KEY (seq)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='카테고리 테이블';

CREATE TABLE tb_review (
	seq SMALLINT UNSIGNED NOT NULL AUTO_INCREMENT COMMENT '리뷰 시퀀스', 
	store_seq SMALLINT UNSIGNED NOT NULL COMMENT '가게 시퀀스',
	member_seq SMALLINT UNSIGNED NOT NULL COMMENT '회원 시퀀스', 
	review_content VARCHAR(1000) NOT NULL COMMENT '리뷰 내용',
	review_img1 VARCHAR(500) COMMENT '리뷰 이미지1', 
	review_img2 VARCHAR(500) COMMENT '리뷰 이미지2', 
	review_img3 VARCHAR(500) COMMENT '리뷰 이미지3', 
	reg_dt DATETIME DEFAULT CURRENT_TIMESTAMP COMMENT '등록일자',
	upd_dt DATETIME ON UPDATE CURRENT_TIMESTAMP COMMENT '수정일자',
	PRIMARY KEY (seq), 
	FOREIGN KEY (store_seq) REFERENCES tb_store(seq) ON UPDATE CASCADE,
	FOREIGN KEY (member_seq) REFERENCES tb_member(seq) ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='리뷰 테이블'; 

LOAD DATA LOCAL INFILE './store.csv' 
INTO TABLE tb_store 
FIELDS TERMINATED BY '|' 
LINES TERMINATED BY '\n';