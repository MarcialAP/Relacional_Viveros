--
-- PostgreSQL database dump
--

\restrict BoKNq6VLcgEt4Iw0hYBb90BbzTzCwWKGiKbZF7GoPuvrlJ5gVAMMKpmQrRNd6HD

-- Dumped from database version 16.10 (Ubuntu 16.10-0ubuntu0.24.04.1)
-- Dumped by pg_dump version 16.10 (Ubuntu 16.10-0ubuntu0.24.04.1)

SET statement_timeout = 0;
SET lock_timeout = 0;
SET idle_in_transaction_session_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SELECT pg_catalog.set_config('search_path', '', false);
SET check_function_bodies = false;
SET xmloption = content;
SET client_min_messages = warning;
SET row_security = off;

--
-- Name: actualizar_precio_total_func(); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.actualizar_precio_total_func() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
BEGIN
    CALL nuevo_producto_compra_proc(NEW.idcompra, NEW.codproducto, NEW.cantidad);
    RETURN NEW;
END;
$$;


ALTER FUNCTION public.actualizar_precio_total_func() OWNER TO postgres;

--
-- Name: actualizar_stock_func(); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.actualizar_stock_func() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
BEGIN
    UPDATE esta_en
    SET cantidad = cantidad - NEW.cantidad
    WHERE idzona = (SELECT idzona FROM trabaja WHERE idempleado = 
    (select idempleado from compra where idcompra = NEW.idcompra LIMIT 1)
    LIMIT 1)
      AND codproducto = NEW.codproducto;
    RETURN NEW;
END;
$$;


ALTER FUNCTION public.actualizar_stock_func() OWNER TO postgres;

--
-- Name: nuevo_producto_compra_proc(integer, integer, integer); Type: PROCEDURE; Schema: public; Owner: postgres
--

CREATE PROCEDURE public.nuevo_producto_compra_proc(IN p_idcompra integer, IN idproducto integer, IN cantidad integer)
    LANGUAGE plpgsql
    AS $$
BEGIN
    UPDATE compra
    SET preciototal = preciototal + (
        (SELECT precio FROM producto WHERE codigo = idproducto) * cantidad
        )
    WHERE idcompra = p_idcompra;
END;
$$;


ALTER PROCEDURE public.nuevo_producto_compra_proc(IN p_idcompra integer, IN idproducto integer, IN cantidad integer) OWNER TO postgres;

SET default_tablespace = '';

SET default_table_access_method = heap;

--
-- Name: cliente; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.cliente (
    codigo integer NOT NULL,
    dni character varying(9),
    telefono character varying(9),
    correo character varying(50),
    fecha_ingreso date,
    nombrecompleto character varying(50),
    identificado boolean DEFAULT true,
    CONSTRAINT cliente_fecha_ingreso_check CHECK ((fecha_ingreso <= CURRENT_DATE)),
    CONSTRAINT cliente_telefono_check CHECK (((telefono)::text ~ '^[0-9]{9}$'::text))
);


ALTER TABLE public.cliente OWNER TO postgres;

--
-- Name: cliente_codigo_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.cliente_codigo_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.cliente_codigo_seq OWNER TO postgres;

--
-- Name: cliente_codigo_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.cliente_codigo_seq OWNED BY public.cliente.codigo;


--
-- Name: compra; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.compra (
    idcompra integer NOT NULL,
    idempleado character varying(9) NOT NULL,
    fecha date NOT NULL,
    preciototal real DEFAULT 0,
    idcliente integer,
    CONSTRAINT compra_preciototal_check CHECK ((preciototal >= (0)::double precision))
);


ALTER TABLE public.compra OWNER TO postgres;

--
-- Name: compra_idcompra_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.compra_idcompra_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.compra_idcompra_seq OWNER TO postgres;

--
-- Name: compra_idcompra_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.compra_idcompra_seq OWNED BY public.compra.idcompra;


--
-- Name: contiene; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.contiene (
    idcompra integer NOT NULL,
    codproducto integer NOT NULL,
    cantidad integer,
    CONSTRAINT contiene_cantidad_check CHECK ((cantidad > 0))
);


ALTER TABLE public.contiene OWNER TO postgres;

--
-- Name: empleado; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.empleado (
    dni character varying(9) NOT NULL,
    nombrecompleto character varying(50) NOT NULL,
    telefono character varying(9) NOT NULL,
    CONSTRAINT empleado_telefono_check CHECK (((telefono)::text ~ '^[0-9]{9}$'::text))
);


ALTER TABLE public.empleado OWNER TO postgres;

--
-- Name: esta_en; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.esta_en (
    idzona integer NOT NULL,
    codproducto integer NOT NULL,
    cantidad integer,
    CONSTRAINT esta_en_cantidad_check CHECK ((cantidad >= 0))
);


ALTER TABLE public.esta_en OWNER TO postgres;

--
-- Name: producto; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.producto (
    codigo integer NOT NULL,
    tipo character varying(50),
    precio real NOT NULL,
    descripcion character varying(100),
    CONSTRAINT producto_precio_check CHECK ((precio > (0)::double precision))
);


ALTER TABLE public.producto OWNER TO postgres;

--
-- Name: producto_codigo_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.producto_codigo_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.producto_codigo_seq OWNER TO postgres;

--
-- Name: producto_codigo_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.producto_codigo_seq OWNED BY public.producto.codigo;


--
-- Name: trabaja; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.trabaja (
    idzona integer NOT NULL,
    idempleado character varying(9) NOT NULL
);


ALTER TABLE public.trabaja OWNER TO postgres;

--
-- Name: vivero; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.vivero (
    codigo integer NOT NULL,
    nombre character varying(50) NOT NULL,
    longitud real NOT NULL,
    latitud real NOT NULL
);


ALTER TABLE public.vivero OWNER TO postgres;

--
-- Name: vivero_codigo_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.vivero_codigo_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.vivero_codigo_seq OWNER TO postgres;

--
-- Name: vivero_codigo_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.vivero_codigo_seq OWNED BY public.vivero.codigo;


--
-- Name: zona; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.zona (
    identificador integer NOT NULL,
    codvivero integer NOT NULL,
    tipo character varying(50) NOT NULL,
    longitud real NOT NULL,
    latitud real NOT NULL
);


ALTER TABLE public.zona OWNER TO postgres;

--
-- Name: zona_identificador_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.zona_identificador_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.zona_identificador_seq OWNER TO postgres;

--
-- Name: zona_identificador_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.zona_identificador_seq OWNED BY public.zona.identificador;


--
-- Name: cliente codigo; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.cliente ALTER COLUMN codigo SET DEFAULT nextval('public.cliente_codigo_seq'::regclass);


--
-- Name: compra idcompra; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.compra ALTER COLUMN idcompra SET DEFAULT nextval('public.compra_idcompra_seq'::regclass);


--
-- Name: producto codigo; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.producto ALTER COLUMN codigo SET DEFAULT nextval('public.producto_codigo_seq'::regclass);


--
-- Name: vivero codigo; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.vivero ALTER COLUMN codigo SET DEFAULT nextval('public.vivero_codigo_seq'::regclass);


--
-- Name: zona identificador; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.zona ALTER COLUMN identificador SET DEFAULT nextval('public.zona_identificador_seq'::regclass);


--
-- Data for Name: cliente; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.cliente (codigo, dni, telefono, correo, fecha_ingreso, nombrecompleto, identificado) FROM stdin;
1	99999991X	611111111	cli1@example.com	2025-09-15	Cliente Uno	t
2	99999992X	611111112	cli2@example.com	2025-09-25	Cliente Dos	t
3	99999993X	611111113	cli3@example.com	2025-10-05	Cliente Tres	t
4	99999994X	611111114	cli4@example.com	2025-10-10	Cliente Cuatro	t
5	99999995X	611111115	cli5@example.com	2025-10-15	Cliente Cinco	t
6	\N	\N	\N	\N	\N	f
7	\N	\N	\N	\N	\N	f
8	\N	\N	\N	\N	\N	f
9	\N	\N	\N	\N	\N	f
10	\N	\N	\N	\N	\N	f
\.


--
-- Data for Name: compra; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.compra (idcompra, idempleado, fecha, preciototal, idcliente) FROM stdin;
5	55555555E	2025-10-15	0	5
2	22222222B	2025-10-05	25	2
3	33333333C	2025-10-10	14	3
4	44444444D	2025-10-12	10	4
1	11111111A	2025-09-30	189.2	1
\.


--
-- Data for Name: contiene; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.contiene (idcompra, codproducto, cantidad) FROM stdin;
1	1	2
2	3	1
3	4	2
4	5	10
1	3	7
1	2	13
\.


--
-- Data for Name: empleado; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.empleado (dni, nombrecompleto, telefono) FROM stdin;
11111111A	Ana López	600111111
22222222B	Carlos Pérez	600222222
33333333C	María García	600333333
44444444D	Luis Martínez	600444444
55555555E	Sofía Ruiz	600555555
\.


--
-- Data for Name: esta_en; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.esta_en (idzona, codproducto, cantidad) FROM stdin;
2	5	50
3	3	5
4	4	8
1	1	8
1	2	1
\.


--
-- Data for Name: producto; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.producto (codigo, tipo, precio, descripcion) FROM stdin;
1	Planta	5.5	Rosa roja
2	Planta	3.2	Margarita blanca
3	Árbol	25	Olivo joven
4	Cactus	7	Cactus pequeño
5	Semilla	1	Semillas mixtas
\.


--
-- Data for Name: trabaja; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.trabaja (idzona, idempleado) FROM stdin;
1	11111111A
1	22222222B
2	33333333C
3	44444444D
4	55555555E
\.


--
-- Data for Name: vivero; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.vivero (codigo, nombre, longitud, latitud) FROM stdin;
1	Vivero Central	-3.70379	40.41678
2	Vivero Norte	-3.703	40.45
3	Vivero Sur	-3.7045	40.38
4	Vivero Este	-3.68	40.416
5	Vivero Oeste	-3.73	40.42
\.


--
-- Data for Name: zona; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.zona (identificador, codvivero, tipo, longitud, latitud) FROM stdin;
1	1	Plantas ornamentales	-3.7037	40.4168
2	1	Semillas	-3.70375	40.41685
3	2	Árboles	-3.7031	40.4505
4	3	Cactus	-3.7046	40.3805
5	4	Herbáceas	-3.6801	40.4161
\.


--
-- Name: cliente_codigo_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.cliente_codigo_seq', 10, true);


--
-- Name: compra_idcompra_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.compra_idcompra_seq', 5, true);


--
-- Name: producto_codigo_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.producto_codigo_seq', 5, true);


--
-- Name: vivero_codigo_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.vivero_codigo_seq', 5, true);


--
-- Name: zona_identificador_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.zona_identificador_seq', 5, true);


--
-- Name: cliente cliente_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.cliente
    ADD CONSTRAINT cliente_pkey PRIMARY KEY (codigo);


--
-- Name: compra compra_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.compra
    ADD CONSTRAINT compra_pkey PRIMARY KEY (idcompra);


--
-- Name: contiene contiene_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.contiene
    ADD CONSTRAINT contiene_pkey PRIMARY KEY (idcompra, codproducto);


--
-- Name: empleado empleado_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.empleado
    ADD CONSTRAINT empleado_pkey PRIMARY KEY (dni);


--
-- Name: esta_en esta_en_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.esta_en
    ADD CONSTRAINT esta_en_pkey PRIMARY KEY (idzona, codproducto);


--
-- Name: producto producto_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.producto
    ADD CONSTRAINT producto_pkey PRIMARY KEY (codigo);


--
-- Name: trabaja trabaja_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.trabaja
    ADD CONSTRAINT trabaja_pkey PRIMARY KEY (idzona, idempleado);


--
-- Name: vivero vivero_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.vivero
    ADD CONSTRAINT vivero_pkey PRIMARY KEY (codigo);


--
-- Name: zona zona_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.zona
    ADD CONSTRAINT zona_pkey PRIMARY KEY (identificador);


--
-- Name: contiene actualizar_precio_total; Type: TRIGGER; Schema: public; Owner: postgres
--

CREATE TRIGGER actualizar_precio_total AFTER INSERT ON public.contiene FOR EACH ROW EXECUTE FUNCTION public.actualizar_precio_total_func();


--
-- Name: contiene actualizar_stock; Type: TRIGGER; Schema: public; Owner: postgres
--

CREATE TRIGGER actualizar_stock AFTER INSERT OR UPDATE ON public.contiene FOR EACH ROW EXECUTE FUNCTION public.actualizar_stock_func();


--
-- Name: compra compra_idcliente_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.compra
    ADD CONSTRAINT compra_idcliente_fkey FOREIGN KEY (idcliente) REFERENCES public.cliente(codigo) ON DELETE SET NULL;


--
-- Name: compra compra_idempleado_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.compra
    ADD CONSTRAINT compra_idempleado_fkey FOREIGN KEY (idempleado) REFERENCES public.empleado(dni);


--
-- Name: contiene contiene_codproducto_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.contiene
    ADD CONSTRAINT contiene_codproducto_fkey FOREIGN KEY (codproducto) REFERENCES public.producto(codigo);


--
-- Name: contiene contiene_idcompra_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.contiene
    ADD CONSTRAINT contiene_idcompra_fkey FOREIGN KEY (idcompra) REFERENCES public.compra(idcompra);


--
-- Name: esta_en esta_en_codproducto_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.esta_en
    ADD CONSTRAINT esta_en_codproducto_fkey FOREIGN KEY (codproducto) REFERENCES public.producto(codigo);


--
-- Name: esta_en esta_en_idzona_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.esta_en
    ADD CONSTRAINT esta_en_idzona_fkey FOREIGN KEY (idzona) REFERENCES public.zona(identificador);


--
-- Name: trabaja trabaja_idempleado_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.trabaja
    ADD CONSTRAINT trabaja_idempleado_fkey FOREIGN KEY (idempleado) REFERENCES public.empleado(dni);


--
-- Name: trabaja trabaja_idzona_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.trabaja
    ADD CONSTRAINT trabaja_idzona_fkey FOREIGN KEY (idzona) REFERENCES public.zona(identificador);


--
-- Name: zona zona_codvivero_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.zona
    ADD CONSTRAINT zona_codvivero_fkey FOREIGN KEY (codvivero) REFERENCES public.vivero(codigo) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- PostgreSQL database dump complete
--

\unrestrict BoKNq6VLcgEt4Iw0hYBb90BbzTzCwWKGiKbZF7GoPuvrlJ5gVAMMKpmQrRNd6HD

