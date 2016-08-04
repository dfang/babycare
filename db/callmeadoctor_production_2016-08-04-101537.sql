--
-- PostgreSQL database dump
--

SET statement_timeout = 0;
SET lock_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SET check_function_bodies = false;
SET client_min_messages = warning;

--
-- Name: plpgsql; Type: EXTENSION; Schema: -; Owner: -
--

CREATE EXTENSION IF NOT EXISTS plpgsql WITH SCHEMA pg_catalog;


--
-- Name: EXTENSION plpgsql; Type: COMMENT; Schema: -; Owner: -
--

COMMENT ON EXTENSION plpgsql IS 'PL/pgSQL procedural language';


SET search_path = public, pg_catalog;

SET default_tablespace = '';

SET default_with_oids = false;

--
-- Name: admin_users; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE admin_users (
    id integer NOT NULL,
    email character varying DEFAULT ''::character varying NOT NULL,
    encrypted_password character varying DEFAULT ''::character varying NOT NULL,
    reset_password_token character varying,
    reset_password_sent_at timestamp without time zone,
    remember_created_at timestamp without time zone,
    sign_in_count integer DEFAULT 0 NOT NULL,
    current_sign_in_at timestamp without time zone,
    last_sign_in_at timestamp without time zone,
    current_sign_in_ip inet,
    last_sign_in_ip inet,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


--
-- Name: admin_users_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE admin_users_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: admin_users_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE admin_users_id_seq OWNED BY admin_users.id;


--
-- Name: authentications; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE authentications (
    id integer NOT NULL,
    provider character varying,
    uid character varying,
    user_id integer,
    nickname character varying,
    unionid character varying,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


--
-- Name: authentications_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE authentications_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: authentications_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE authentications_id_seq OWNED BY authentications.id;


--
-- Name: checkins; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE checkins (
    id integer NOT NULL,
    name character varying,
    mobile_phone character varying,
    birthdate character varying,
    gender character varying,
    email character varying,
    job character varying,
    employer character varying,
    nationality character varying,
    province_id character varying,
    city_id character varying,
    area_id character varying,
    address character varying,
    source character varying,
    remark text,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


--
-- Name: checkins_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE checkins_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: checkins_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE checkins_id_seq OWNED BY checkins.id;


--
-- Name: cities; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE cities (
    id integer NOT NULL,
    name character varying,
    province_id integer,
    level integer,
    zip_code character varying,
    pinyin character varying,
    pinyin_abbr character varying,
    created_at timestamp without time zone,
    updated_at timestamp without time zone
);


--
-- Name: cities_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE cities_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: cities_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE cities_id_seq OWNED BY cities.id;


--
-- Name: districts; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE districts (
    id integer NOT NULL,
    name character varying,
    city_id integer,
    pinyin character varying,
    pinyin_abbr character varying,
    created_at timestamp without time zone,
    updated_at timestamp without time zone
);


--
-- Name: districts_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE districts_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: districts_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE districts_id_seq OWNED BY districts.id;


--
-- Name: doctors; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE doctors (
    id integer NOT NULL,
    name character varying,
    gender character varying,
    age integer,
    hospital character varying,
    location character varying,
    lat double precision,
    long double precision,
    verified boolean,
    date_of_birth date,
    mobile_phone character varying,
    remark text,
    id_card_num character varying,
    id_card_front character varying,
    id_card_back character varying,
    license_front character varying,
    license_back character varying,
    job_title character varying,
    user_id integer,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


--
-- Name: doctors_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE doctors_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: doctors_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE doctors_id_seq OWNED BY doctors.id;


--
-- Name: global_images; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE global_images (
    id integer NOT NULL,
    user_id integer,
    data character varying,
    target_type character varying,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


--
-- Name: global_images_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE global_images_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: global_images_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE global_images_id_seq OWNED BY global_images.id;


--
-- Name: images; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE images (
    id integer NOT NULL,
    data character varying,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


--
-- Name: images_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE images_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: images_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE images_id_seq OWNED BY images.id;


--
-- Name: imaging_examination_images; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE imaging_examination_images (
    id integer NOT NULL,
    medical_record_id integer,
    data character varying,
    is_cover boolean,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


--
-- Name: imaging_examination_images_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE imaging_examination_images_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: imaging_examination_images_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE imaging_examination_images_id_seq OWNED BY imaging_examination_images.id;


--
-- Name: laboratory_examination_images; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE laboratory_examination_images (
    id integer NOT NULL,
    medical_record_id integer,
    data character varying,
    is_cover boolean,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


--
-- Name: laboratory_examination_images_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE laboratory_examination_images_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: laboratory_examination_images_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE laboratory_examination_images_id_seq OWNED BY laboratory_examination_images.id;


--
-- Name: medical_record_images; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE medical_record_images (
    id integer NOT NULL,
    medical_record_id integer,
    data character varying,
    is_cover boolean,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


--
-- Name: medical_record_images_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE medical_record_images_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: medical_record_images_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE medical_record_images_id_seq OWNED BY medical_record_images.id;


--
-- Name: medical_records; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE medical_records (
    id integer NOT NULL,
    person_id integer,
    onset_date date,
    chief_complaint text,
    history_of_present_illness text,
    past_medical_history text,
    allergic_history boolean,
    personal_history text,
    family_history text,
    vaccination_history text,
    physical_examination text,
    laboratory_and_supplementary_examinations text,
    preliminary_diagnosis text,
    treatment_recommendation text,
    remarks text,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL,
    imaging_examination text,
    height integer,
    weight double precision,
    bmi double precision,
    temperature double precision,
    pulse integer,
    respiratory_rate integer,
    blood_pressure integer,
    oxygen_saturation character varying,
    pain_score integer
);


--
-- Name: medical_records_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE medical_records_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: medical_records_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE medical_records_id_seq OWNED BY medical_records.id;


--
-- Name: people; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE people (
    id integer NOT NULL,
    name character varying,
    mobile_phone character varying,
    birthdate date,
    gender character varying,
    email character varying,
    job character varying,
    employer character varying,
    nationality character varying,
    province_id character varying,
    city_id character varying,
    district_id character varying,
    address character varying,
    source character varying,
    wechat character varying,
    qq character varying,
    remark text,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL,
    parent_id integer,
    lft integer,
    rgt integer,
    depth integer,
    children_count integer,
    blood_type character varying
);


--
-- Name: people_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE people_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: people_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE people_id_seq OWNED BY people.id;


--
-- Name: posts; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE posts (
    id integer NOT NULL,
    title character varying,
    description text,
    content text,
    category integer,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


--
-- Name: posts_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE posts_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: posts_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE posts_id_seq OWNED BY posts.id;


--
-- Name: provinces; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE provinces (
    id integer NOT NULL,
    name character varying,
    pinyin character varying,
    pinyin_abbr character varying,
    created_at timestamp without time zone,
    updated_at timestamp without time zone
);


--
-- Name: provinces_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE provinces_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: provinces_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE provinces_id_seq OWNED BY provinces.id;


--
-- Name: reservations; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE reservations (
    id integer NOT NULL,
    name character varying,
    mobile_phone character varying,
    remark character varying,
    location character varying,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL,
    aasm_state character varying,
    reservation_time timestamp without time zone,
    reservation_location character varying,
    reservation_phone character varying,
    user_a integer,
    user_b integer
);


--
-- Name: reservations_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE reservations_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: reservations_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE reservations_id_seq OWNED BY reservations.id;


--
-- Name: schema_migrations; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE schema_migrations (
    version character varying NOT NULL
);


--
-- Name: users; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE users (
    id integer NOT NULL,
    email character varying DEFAULT ''::character varying NOT NULL,
    encrypted_password character varying DEFAULT ''::character varying NOT NULL,
    reset_password_token character varying,
    reset_password_sent_at timestamp without time zone,
    remember_created_at timestamp without time zone,
    sign_in_count integer DEFAULT 0 NOT NULL,
    current_sign_in_at timestamp without time zone,
    last_sign_in_at timestamp without time zone,
    current_sign_in_ip inet,
    last_sign_in_ip inet,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL,
    name character varying,
    gender character varying,
    avatar character varying
);


--
-- Name: users_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE users_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: users_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE users_id_seq OWNED BY users.id;


--
-- Name: wx_menus; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE wx_menus (
    id integer NOT NULL,
    menu_type character varying,
    name character varying,
    key character varying,
    url character varying,
    sequence integer,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


--
-- Name: wx_menus_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE wx_menus_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: wx_menus_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE wx_menus_id_seq OWNED BY wx_menus.id;


--
-- Name: wx_sub_menus; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE wx_sub_menus (
    id integer NOT NULL,
    wx_menu_id integer,
    menu_type character varying,
    name character varying,
    key character varying,
    url character varying,
    sequence integer,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


--
-- Name: wx_sub_menus_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE wx_sub_menus_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: wx_sub_menus_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE wx_sub_menus_id_seq OWNED BY wx_sub_menus.id;


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY admin_users ALTER COLUMN id SET DEFAULT nextval('admin_users_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY authentications ALTER COLUMN id SET DEFAULT nextval('authentications_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY checkins ALTER COLUMN id SET DEFAULT nextval('checkins_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY cities ALTER COLUMN id SET DEFAULT nextval('cities_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY districts ALTER COLUMN id SET DEFAULT nextval('districts_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY doctors ALTER COLUMN id SET DEFAULT nextval('doctors_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY global_images ALTER COLUMN id SET DEFAULT nextval('global_images_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY images ALTER COLUMN id SET DEFAULT nextval('images_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY imaging_examination_images ALTER COLUMN id SET DEFAULT nextval('imaging_examination_images_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY laboratory_examination_images ALTER COLUMN id SET DEFAULT nextval('laboratory_examination_images_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY medical_record_images ALTER COLUMN id SET DEFAULT nextval('medical_record_images_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY medical_records ALTER COLUMN id SET DEFAULT nextval('medical_records_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY people ALTER COLUMN id SET DEFAULT nextval('people_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY posts ALTER COLUMN id SET DEFAULT nextval('posts_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY provinces ALTER COLUMN id SET DEFAULT nextval('provinces_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY reservations ALTER COLUMN id SET DEFAULT nextval('reservations_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY users ALTER COLUMN id SET DEFAULT nextval('users_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY wx_menus ALTER COLUMN id SET DEFAULT nextval('wx_menus_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY wx_sub_menus ALTER COLUMN id SET DEFAULT nextval('wx_sub_menus_id_seq'::regclass);


--
-- Data for Name: admin_users; Type: TABLE DATA; Schema: public; Owner: -
--

COPY admin_users (id, email, encrypted_password, reset_password_token, reset_password_sent_at, remember_created_at, sign_in_count, current_sign_in_at, last_sign_in_at, current_sign_in_ip, last_sign_in_ip, created_at, updated_at) FROM stdin;
\.


--
-- Name: admin_users_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('admin_users_id_seq', 1, false);


--
-- Data for Name: authentications; Type: TABLE DATA; Schema: public; Owner: -
--

COPY authentications (id, provider, uid, user_id, nickname, unionid, created_at, updated_at) FROM stdin;
3	wechat	ox-t3s_BIGA0KgFWzwNrnFE-pE28	3	王云	ox-t3s_BIGA0KgFWzwNrnFE-pE28	2016-08-03 07:11:19.057743	2016-08-03 07:11:19.057743
2	wechat	ox-t3swaGARmDU8LDirgop3O0GKc	2	Prince	ox-t3swaGARmDU8LDirgop3O0GKc	2016-08-03 07:07:47.835859	2016-08-03 07:07:47.835859
1	wechat	ox-t3s08e-Av2rUlE2a2i2ITR0XY	1	Fang Duan	ox-t3s08e-Av2rUlE2a2i2ITR0XY	2016-08-03 05:49:26.205469	2016-08-03 05:49:26.205469
\.


--
-- Name: authentications_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('authentications_id_seq', 3, true);


--
-- Data for Name: checkins; Type: TABLE DATA; Schema: public; Owner: -
--

COPY checkins (id, name, mobile_phone, birthdate, gender, email, job, employer, nationality, province_id, city_id, area_id, address, source, remark, created_at, updated_at) FROM stdin;
\.


--
-- Name: checkins_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('checkins_id_seq', 1, false);


--
-- Data for Name: cities; Type: TABLE DATA; Schema: public; Owner: -
--

COPY cities (id, name, province_id, level, zip_code, pinyin, pinyin_abbr, created_at, updated_at) FROM stdin;
\.


--
-- Name: cities_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('cities_id_seq', 1, false);


--
-- Data for Name: districts; Type: TABLE DATA; Schema: public; Owner: -
--

COPY districts (id, name, city_id, pinyin, pinyin_abbr, created_at, updated_at) FROM stdin;
\.


--
-- Name: districts_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('districts_id_seq', 1, false);


--
-- Data for Name: doctors; Type: TABLE DATA; Schema: public; Owner: -
--

COPY doctors (id, name, gender, age, hospital, location, lat, long, verified, date_of_birth, mobile_phone, remark, id_card_num, id_card_front, id_card_back, license_front, license_back, job_title, user_id, created_at, updated_at) FROM stdin;
3	阿里郎	0	\N	\N	\N	\N	\N	t	1981-08-03	18802709638	英文对话	\N	\N	\N	\N	\N	\N	3	2016-08-03 07:11:59.156406	2016-08-03 08:57:46.015706
2	段访	0	\N	\N	\N	\N	\N	t	\N			\N	\N	\N	\N	\N	\N	2	2016-08-03 07:08:01.923668	2016-08-03 08:57:47.741647
1	菲尔	0	\N	湖北省中医院	珞瑜路38号	\N	\N	t	1981-03-03	18802709638	可以英语交流	421124198712280030	http://7xrod3.com1.z0.glb.clouddn.com/common/2b9de12c-fced-43f8-a74f-7241d8845fb4.jpeg?e=1470207097&amp;token=4ZphZ7CCpJmmeTl3JltPd0AUSwXFlZR4L5EcX4xi:62VsFPO-aZZkbWfmVeezylosiVs=	http://7xrod3.com1.z0.glb.clouddn.com/common/f49b9c19-4508-4e8d-92a7-05371fb2198c.jpeg?e=1470207112&amp;token=4ZphZ7CCpJmmeTl3JltPd0AUSwXFlZR4L5EcX4xi:WW5fJTjHxqIinN6Yhbr8m8v7uwI=	http://7xrod3.com1.z0.glb.clouddn.com/common/f47280d7-0c3e-4228-8a06-0ad27dceb641.jpeg?e=1470207120&amp;token=4ZphZ7CCpJmmeTl3JltPd0AUSwXFlZR4L5EcX4xi:bb_zLolhe_vwmfLNdhz92ZXSufo=		\N	1	2016-08-03 05:50:18.128991	2016-08-03 08:57:49.329607
\.


--
-- Name: doctors_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('doctors_id_seq', 3, true);


--
-- Data for Name: global_images; Type: TABLE DATA; Schema: public; Owner: -
--

COPY global_images (id, user_id, data, target_type, created_at, updated_at) FROM stdin;
1	\N	2b9de12c-fced-43f8-a74f-7241d8845fb4.jpeg	\N	2016-08-03 05:51:35.594563	2016-08-03 05:51:35.594563
2	\N	f49b9c19-4508-4e8d-92a7-05371fb2198c.jpeg	\N	2016-08-03 05:51:50.917152	2016-08-03 05:51:50.917152
3	\N	f47280d7-0c3e-4228-8a06-0ad27dceb641.jpeg	\N	2016-08-03 05:51:58.419371	2016-08-03 05:51:58.419371
4	\N	4aa20da1-47dd-40d0-908e-93665d2d87a3.jpg	\N	2016-08-03 07:17:54.622116	2016-08-03 07:17:54.622116
5	\N	a801a9c2-71b1-43ec-a257-648c3e6c0f14.jpg	\N	2016-08-03 07:18:04.397458	2016-08-03 07:18:04.397458
6	\N	48fdc68d-5f0c-4a95-ace5-9576e4198c8b.jpg	\N	2016-08-03 08:01:01.945532	2016-08-03 08:01:01.945532
7	\N	c89cc1b2-643b-4b89-a2c9-1364442cb640.jpeg	\N	2016-08-03 08:01:10.03088	2016-08-03 08:01:10.03088
\.


--
-- Name: global_images_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('global_images_id_seq', 7, true);


--
-- Data for Name: images; Type: TABLE DATA; Schema: public; Owner: -
--

COPY images (id, data, created_at, updated_at) FROM stdin;
\.


--
-- Name: images_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('images_id_seq', 1, false);


--
-- Data for Name: imaging_examination_images; Type: TABLE DATA; Schema: public; Owner: -
--

COPY imaging_examination_images (id, medical_record_id, data, is_cover, created_at, updated_at) FROM stdin;
\.


--
-- Name: imaging_examination_images_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('imaging_examination_images_id_seq', 1, false);


--
-- Data for Name: laboratory_examination_images; Type: TABLE DATA; Schema: public; Owner: -
--

COPY laboratory_examination_images (id, medical_record_id, data, is_cover, created_at, updated_at) FROM stdin;
\.


--
-- Name: laboratory_examination_images_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('laboratory_examination_images_id_seq', 1, false);


--
-- Data for Name: medical_record_images; Type: TABLE DATA; Schema: public; Owner: -
--

COPY medical_record_images (id, medical_record_id, data, is_cover, created_at, updated_at) FROM stdin;
\.


--
-- Name: medical_record_images_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('medical_record_images_id_seq', 1, false);


--
-- Data for Name: medical_records; Type: TABLE DATA; Schema: public; Owner: -
--

COPY medical_records (id, person_id, onset_date, chief_complaint, history_of_present_illness, past_medical_history, allergic_history, personal_history, family_history, vaccination_history, physical_examination, laboratory_and_supplementary_examinations, preliminary_diagnosis, treatment_recommendation, remarks, created_at, updated_at, imaging_examination, height, weight, bmi, temperature, pulse, respiratory_rate, blood_pressure, oxygen_saturation, pain_score) FROM stdin;
\.


--
-- Name: medical_records_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('medical_records_id_seq', 1, false);


--
-- Data for Name: people; Type: TABLE DATA; Schema: public; Owner: -
--

COPY people (id, name, mobile_phone, birthdate, gender, email, job, employer, nationality, province_id, city_id, district_id, address, source, wechat, qq, remark, created_at, updated_at, parent_id, lft, rgt, depth, children_count, blood_type) FROM stdin;
\.


--
-- Name: people_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('people_id_seq', 1, false);


--
-- Data for Name: posts; Type: TABLE DATA; Schema: public; Owner: -
--

COPY posts (id, title, description, content, category, created_at, updated_at) FROM stdin;
\.


--
-- Name: posts_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('posts_id_seq', 1, false);


--
-- Data for Name: provinces; Type: TABLE DATA; Schema: public; Owner: -
--

COPY provinces (id, name, pinyin, pinyin_abbr, created_at, updated_at) FROM stdin;
\.


--
-- Name: provinces_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('provinces_id_seq', 1, false);


--
-- Data for Name: reservations; Type: TABLE DATA; Schema: public; Owner: -
--

COPY reservations (id, name, mobile_phone, remark, location, created_at, updated_at, aasm_state, reservation_time, reservation_location, reservation_phone, user_a, user_b) FROM stdin;
1	王先生	18802709638	发烧三天，咳嗽有痰。	光谷	2016-08-03 08:05:46.664281	2016-08-03 08:07:12.806325	pending	\N	\N	\N	3	1
2	王子奇	15618903074	将近 	费哦图	2016-08-03 08:11:29.557229	2016-08-03 08:11:29.557229	pending	\N	\N	\N	1	\N
3	王一事	1234567890	躲躲藏藏	武昌	2016-08-03 08:11:42.964188	2016-08-03 08:11:42.964188	pending	\N	\N	\N	3	\N
4	曾先生	15644888885	55666	4664648	2016-08-03 08:24:44.566532	2016-08-03 08:24:44.566532	pending	\N	\N	\N	1	\N
\.


--
-- Name: reservations_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('reservations_id_seq', 4, true);


--
-- Data for Name: schema_migrations; Type: TABLE DATA; Schema: public; Owner: -
--

COPY schema_migrations (version) FROM stdin;
20151116055708
20151116055729
20160603031548
20160605231547
20160606001939
20160607012007
20160607041248
20160608004934
20160608031155
20160613020342
20160613020532
20160613020535
20160614011640
20160614041146
20160614061350
20160714032849
20160714043605
20160714054911
20160714063215
20160714063311
20160714063359
20160714080333
20160715022509
20160715033957
20160728003442
20160731011142
20160731032832
20160731032916
\.


--
-- Data for Name: users; Type: TABLE DATA; Schema: public; Owner: -
--

COPY users (id, email, encrypted_password, reset_password_token, reset_password_sent_at, remember_created_at, sign_in_count, current_sign_in_at, last_sign_in_at, current_sign_in_ip, last_sign_in_ip, created_at, updated_at, name, gender, avatar) FROM stdin;
2	wx_user_f7cb10b8bf1f3dbc1d33ae03036e201f@wx_email.com		\N	\N	\N	2	2016-08-03 08:05:27.467579	2016-08-03 07:07:47.848334	140.207.54.198	140.207.54.198	2016-08-03 07:07:47.824971	2016-08-03 08:05:27.469897	Prince	1	http://wx.qlogo.cn/mmopen/eaYv4DAT2oZ5h1yLXvLHe5A91Eib51Zq7IQcJtVomJZGlSiaKeL4vB4T07DBricj9hKJHf233ib4SocKXzLshj9neaUdHxh1ZdWo/0
3	wx_user_25db51de0cfe7afc85d7e4e21f76eee6@wx_email.com		\N	\N	\N	4	2016-08-03 08:17:07.159694	2016-08-03 08:08:32.991653	140.207.54.180	101.226.68.141	2016-08-03 07:11:19.053103	2016-08-03 08:17:07.162359	王云	1	http://wx.qlogo.cn/mmopen/PiajxSqBRaEJqhSicdDicxL0PZEKLCTZLVmjibk0sQJakQpmk2JicdyRm8ia8rHmCTc2qBWbGlUybOfKVJ0U5SY9u40Q/0
1	wx_user_3edf8c26f775c79e13dd432a004507c6@wx_email.com		\N	\N	\N	5	2016-08-04 02:04:42.157857	2016-08-03 13:13:04.741639	113.57.178.60	121.60.119.5	2016-08-03 05:49:26.19447	2016-08-04 02:04:42.159627	Fang Duan	1	http://wx.qlogo.cn/mmopen/PiajxSqBRaEKhgic1TjGBnPjm1kRdbrPNVstrDeCyAibmYSYuXwvibeUItDza0ElHibILDVDC1aYbVkNDBYiayYdLJeA/0
\.


--
-- Name: users_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('users_id_seq', 3, true);


--
-- Data for Name: wx_menus; Type: TABLE DATA; Schema: public; Owner: -
--

COPY wx_menus (id, menu_type, name, key, url, sequence, created_at, updated_at) FROM stdin;
\.


--
-- Name: wx_menus_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('wx_menus_id_seq', 1, false);


--
-- Data for Name: wx_sub_menus; Type: TABLE DATA; Schema: public; Owner: -
--

COPY wx_sub_menus (id, wx_menu_id, menu_type, name, key, url, sequence, created_at, updated_at) FROM stdin;
\.


--
-- Name: wx_sub_menus_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('wx_sub_menus_id_seq', 1, false);


--
-- Name: admin_users_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY admin_users
    ADD CONSTRAINT admin_users_pkey PRIMARY KEY (id);


--
-- Name: authentications_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY authentications
    ADD CONSTRAINT authentications_pkey PRIMARY KEY (id);


--
-- Name: checkins_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY checkins
    ADD CONSTRAINT checkins_pkey PRIMARY KEY (id);


--
-- Name: cities_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY cities
    ADD CONSTRAINT cities_pkey PRIMARY KEY (id);


--
-- Name: districts_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY districts
    ADD CONSTRAINT districts_pkey PRIMARY KEY (id);


--
-- Name: doctors_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY doctors
    ADD CONSTRAINT doctors_pkey PRIMARY KEY (id);


--
-- Name: global_images_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY global_images
    ADD CONSTRAINT global_images_pkey PRIMARY KEY (id);


--
-- Name: images_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY images
    ADD CONSTRAINT images_pkey PRIMARY KEY (id);


--
-- Name: imaging_examination_images_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY imaging_examination_images
    ADD CONSTRAINT imaging_examination_images_pkey PRIMARY KEY (id);


--
-- Name: laboratory_examination_images_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY laboratory_examination_images
    ADD CONSTRAINT laboratory_examination_images_pkey PRIMARY KEY (id);


--
-- Name: medical_record_images_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY medical_record_images
    ADD CONSTRAINT medical_record_images_pkey PRIMARY KEY (id);


--
-- Name: medical_records_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY medical_records
    ADD CONSTRAINT medical_records_pkey PRIMARY KEY (id);


--
-- Name: people_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY people
    ADD CONSTRAINT people_pkey PRIMARY KEY (id);


--
-- Name: posts_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY posts
    ADD CONSTRAINT posts_pkey PRIMARY KEY (id);


--
-- Name: provinces_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY provinces
    ADD CONSTRAINT provinces_pkey PRIMARY KEY (id);


--
-- Name: reservations_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY reservations
    ADD CONSTRAINT reservations_pkey PRIMARY KEY (id);


--
-- Name: users_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY users
    ADD CONSTRAINT users_pkey PRIMARY KEY (id);


--
-- Name: wx_menus_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY wx_menus
    ADD CONSTRAINT wx_menus_pkey PRIMARY KEY (id);


--
-- Name: wx_sub_menus_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY wx_sub_menus
    ADD CONSTRAINT wx_sub_menus_pkey PRIMARY KEY (id);


--
-- Name: index_admin_users_on_email; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE UNIQUE INDEX index_admin_users_on_email ON admin_users USING btree (email);


--
-- Name: index_admin_users_on_reset_password_token; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE UNIQUE INDEX index_admin_users_on_reset_password_token ON admin_users USING btree (reset_password_token);


--
-- Name: index_cities_on_level; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_cities_on_level ON cities USING btree (level);


--
-- Name: index_cities_on_name; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_cities_on_name ON cities USING btree (name);


--
-- Name: index_cities_on_pinyin; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_cities_on_pinyin ON cities USING btree (pinyin);


--
-- Name: index_cities_on_pinyin_abbr; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_cities_on_pinyin_abbr ON cities USING btree (pinyin_abbr);


--
-- Name: index_cities_on_province_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_cities_on_province_id ON cities USING btree (province_id);


--
-- Name: index_cities_on_zip_code; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_cities_on_zip_code ON cities USING btree (zip_code);


--
-- Name: index_districts_on_city_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_districts_on_city_id ON districts USING btree (city_id);


--
-- Name: index_districts_on_name; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_districts_on_name ON districts USING btree (name);


--
-- Name: index_districts_on_pinyin; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_districts_on_pinyin ON districts USING btree (pinyin);


--
-- Name: index_districts_on_pinyin_abbr; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_districts_on_pinyin_abbr ON districts USING btree (pinyin_abbr);


--
-- Name: index_doctors_on_user_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_doctors_on_user_id ON doctors USING btree (user_id);


--
-- Name: index_global_images_on_user_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_global_images_on_user_id ON global_images USING btree (user_id);


--
-- Name: index_imaging_examination_images_on_medical_record_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_imaging_examination_images_on_medical_record_id ON imaging_examination_images USING btree (medical_record_id);


--
-- Name: index_laboratory_examination_images_on_medical_record_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_laboratory_examination_images_on_medical_record_id ON laboratory_examination_images USING btree (medical_record_id);


--
-- Name: index_medical_record_images_on_medical_record_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_medical_record_images_on_medical_record_id ON medical_record_images USING btree (medical_record_id);


--
-- Name: index_medical_records_on_person_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_medical_records_on_person_id ON medical_records USING btree (person_id);


--
-- Name: index_provinces_on_name; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_provinces_on_name ON provinces USING btree (name);


--
-- Name: index_provinces_on_pinyin; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_provinces_on_pinyin ON provinces USING btree (pinyin);


--
-- Name: index_provinces_on_pinyin_abbr; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_provinces_on_pinyin_abbr ON provinces USING btree (pinyin_abbr);


--
-- Name: index_users_on_email; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE UNIQUE INDEX index_users_on_email ON users USING btree (email);


--
-- Name: index_users_on_reset_password_token; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE UNIQUE INDEX index_users_on_reset_password_token ON users USING btree (reset_password_token);


--
-- Name: index_wx_sub_menus_on_wx_menu_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_wx_sub_menus_on_wx_menu_id ON wx_sub_menus USING btree (wx_menu_id);


--
-- Name: unique_schema_migrations; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE UNIQUE INDEX unique_schema_migrations ON schema_migrations USING btree (version);


--
-- Name: fk_rails_5afc19beb3; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY laboratory_examination_images
    ADD CONSTRAINT fk_rails_5afc19beb3 FOREIGN KEY (medical_record_id) REFERENCES medical_records(id);


--
-- Name: fk_rails_758eabdc78; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY imaging_examination_images
    ADD CONSTRAINT fk_rails_758eabdc78 FOREIGN KEY (medical_record_id) REFERENCES medical_records(id);


--
-- Name: fk_rails_899b01ef33; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY doctors
    ADD CONSTRAINT fk_rails_899b01ef33 FOREIGN KEY (user_id) REFERENCES users(id);


--
-- Name: fk_rails_9126b0e8c1; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY medical_record_images
    ADD CONSTRAINT fk_rails_9126b0e8c1 FOREIGN KEY (medical_record_id) REFERENCES medical_records(id);


--
-- Name: fk_rails_a0b40c078a; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY wx_sub_menus
    ADD CONSTRAINT fk_rails_a0b40c078a FOREIGN KEY (wx_menu_id) REFERENCES wx_menus(id);


--
-- Name: fk_rails_b0ab412b77; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY global_images
    ADD CONSTRAINT fk_rails_b0ab412b77 FOREIGN KEY (user_id) REFERENCES users(id);


--
-- Name: fk_rails_cfb04dd1c0; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY medical_records
    ADD CONSTRAINT fk_rails_cfb04dd1c0 FOREIGN KEY (person_id) REFERENCES people(id);


--
-- PostgreSQL database dump complete
--

