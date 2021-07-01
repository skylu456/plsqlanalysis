CREATE TABLE SucursalAhorros(cod_sucursal int primary key not null,
nombresucursal varchar2(40), montoAhorro number);

CREATE TABLE SucursalTipoAhorro(id_TypeAhorro int primary key not null, 
cod_sucursal number not null, tipoAhorro varchar2(40),montoAhorro number, 
CONSTRAINT fk_cod_sucursal FOREIGN KEY (cod_sucursal) REFERENCES sucursalAhorros(cod_sucursal));

CREATE TABLE tiposAhorros(id_typeAhorros int primary key not null, 
descripcion varchar2(40), tasa_intAhorros number);

CREATE TABLE Ahorros(id_ahorro int,
id_typeAhorros number not null,
cod_sucursal number not null, id_cliente number not null, tipoAhorro varchar2(40),
num_cuenta number not null, fecha_aper date, tasa_int number, letra_deposito number, 
saldo_ahorro number, saldo_int number, fecha_deposito date, fecha_ret number,
usuario varchar2(40), fecha_mod date,
CONSTRAINT fk_cod_sucursal2 FOREIGN KEY (cod_sucursal) REFERENCES sucursal(cod_sucursal),
CONSTRAINT fk_idcliente FOREIGN KEY (id_cliente) REFERENCES cliente(id_cliente),
CONSTRAINT fk_idTypeAhorros FOREIGN KEY (id_TypeAhorros) REFERENCES tiposAhorros(id_typeAhorros));

CREATE TABLE auditoria(Id_transaccion int  not null, 
id_cliente number not null, id_typeAhorros int not null, type_transac number,
saldo_anterior number, monto number, saldo_f number,
usuario varchar2(40), fecha date, tabla varchar2(40),
CONSTRAINT fk_idcliente2 FOREIGN KEY (id_cliente) REFERENCES cliente(id_cliente),
CONSTRAINT fk_typeAhorro FOREIGN KEY (id_typeAhorros) REFERENCES tiposAhorros(id_typeAhorros));
 

CREATE TABLE transadeporti(cod_sucursal number not null, id_transaccion int primary key not null,
id_cliente number not null, id_typeAhorros int not null, fecha_transac date, 
tipoTransac int, monto number , fecha_insert date, 
CONSTRAINT fk_cliente FOREIGN KEY (id_cliente) REFERENCES Cliente(id_cliente),
CONSTRAINT fk2_typeAhorros FOREIGN KEY (id_typeAhorros) REFERENCES tiposAhorros(id_typeAhorros));

--PL SQL

--SECUENCIAS

CREATE SEQUENCE type_ahorro_seq
START WITH 1
INCREMENT BY 1
;

CREATE SEQUENCE type_sucurahorro_seq
START WITH 1
INCREMENT BY 1
;

CREATE SEQUENCE ahorro2_seq
START WITH 1
INCREMENT BY 1
;

CREATE SEQUENCE transac_seq
START WITH 1
INCREMENT BY 1
;


CREATE SEQUENCE num_cuenta
START WITH 1
INCREMENT BY 1
;

CREATE OR REPLACE PROCEDURE add_TypeAhorros(
p_tasaintAhorros IN tiposAhorros.tasa_intAhorros%TYPE,
p_desc IN tiposAhorros.descripcion%TYPE)AS

BEGIN
    INSERT INTO tiposAhorros VALUES(type_ahorro_seq.nextval,p_desc, p_tasaintAhorros);
EXCEPTION 
    WHEN program_error THEN 
    dbms_output.put_line('Hubo un error en el PL/SQL. Vuelve a intentarlo.');
    WHEN dup_val_on_index THEN 
    DBMS_OUTPUT.PUT_LINE('Hubo un error de duplicación. Revisa los parametros.');
    WHEN OTHERS THEN
    DBMS_OUTPUT.PUT_LINE('Error desconocido.');
END add_TypeAhorros;

BEGIN
    add_TypeAhorros(0.06, 'Navidad' );
    add_TypeAhorros(0.04, 'Corriente' );
    add_TypeAhorros(0.06, 'Estudiante' );
END;    

CREATE OR REPLACE PROCEDURE AddSucursalAhorros(
p_codSucur IN sucursalTipoAhorro.cod_sucursal%TYPE,
p_typeSave IN sucursalTipoAhorro.tipoAhorro%TYPE)AS

BEGIN
    INSERT INTO SucursalTipoAhorro VALUES(type_sucurahorro_seq.nextval,p_codSucur
    , p_typeSave,0);
EXCEPTION 
    WHEN program_error THEN 
    dbms_output.put_line('Hubo un error en el PL/SQL. Vuelve a intentarlo.');
    WHEN dup_val_on_index THEN 
    DBMS_OUTPUT.PUT_LINE('Hubo un error de duplicación. Revisa los parametros.');
    WHEN OTHERS THEN
    DBMS_OUTPUT.PUT_LINE('Error desconocido.');
END AddSucursalAhorros;

BEGIN
    AddSucursalAhorros(1,'Navidad');
    AddSucursalAhorros(2,'Corriente');
    AddSucursalAhorros(1,'Educacion');
END;

CREATE OR REPLACE PROCEDURE addAhorroApr(
p_codSucur IN Ahorros.cod_sucursal%TYPE,
p_Idcliente IN Ahorros.id_cliente%TYPE,
p_idTypeAhorro IN Ahorros.id_typeAhorros%TYPE,
p_typeAhorro IN Ahorros.tipoAhorro%TYPE,
p_dateOpen IN Ahorros.fecha_aper%TYPE,
p_tasaint IN Ahorros.tasa_int%TYPE,
p_letraDepo IN Ahorros.letra_deposito%TYPE,
p_saldoAhorro IN Ahorros.saldo_ahorro%TYPE)AS

BEGIN
    INSERT INTO Ahorros VALUES(ahorro2_seq.nextval,p_idTypeAhorro,p_codSucur,
    p_Idcliente,p_typeAhorro,num_Cuenta.nextval, p_dateOpen,p_tasaint,
    p_letraDepo,p_saldoAhorro,0,'','',user,sysdate);
EXCEPTION 
    WHEN program_error THEN 
    dbms_output.put_line('Hubo un error en el PL/SQL. Vuelve a intentarlo.');
    WHEN dup_val_on_index THEN 
    DBMS_OUTPUT.PUT_LINE('Hubo un error de duplicación. Revisa los parametros.');
    WHEN OTHERS THEN
    DBMS_OUTPUT.PUT_LINE('Error desconocido.');
END addAhorroApr;

BEGIN
    addAhorroApr(1,1,1,'Navidad','23-OCT-2015',0.06,55,0);
    addAhorroApr(1,2,2,'Corriente','24-JAN-2018', 0.04,18,0);
    addAhorroApr(1,3,3,'Educacion','24-FEB-2013', 0.06,40,0);
END;

CREATE OR REPLACE PROCEDURE newAhorroTransac(
p_codSucur IN transadeporti.cod_sucursal%TYPE,
p_idCliente IN transadeporti.id_cliente%TYPE,
p_idtypeAhorro IN transadeporti.id_typeAhorros%TYPE,
p_fechaTransac IN transadeporti.fecha_Transac%TYPE,
p_transacType IN transadeporti.tipoTransac%TYPE,
p_monto IN transadeporti.monto%TYPE)AS

BEGIN
    INSERT INTO transadeporti VALUES(transac_seq.nextval,p_codSucur,
    p_Idcliente,p_idTypeAhorro,p_fechaTransac, p_transacType,p_monto,
    sysdate);
EXCEPTION 
    WHEN program_error THEN 
    dbms_output.put_line('Hubo un error en el PL/SQL. Vuelve a intentarlo.');
    WHEN dup_val_on_index THEN 
    DBMS_OUTPUT.PUT_LINE('Hubo un error de duplicación. Revisa los parametros.');
    WHEN OTHERS THEN
    DBMS_OUTPUT.PUT_LINE('Error desconocido.');
END newAhorroTransac;
delete from transadeporti;
BEGIN
    newAhorroTransac(1,1,1,sysdate,1,778);
    newAhorroTransac(2,2,1,sysdate,1,778);
    newAhorroTransac(2,3,2,sysdate,1,578);
END;

CREATE OR REPLACE FUNCTION calcInteres(
p_tasaInt number, p_monto number)RETURN NUMBER IS
v_nuevoMonto number;
BEGIN
    v_nuevoMonto := p_monto*p_tasaInt;
    RETURN v_nuevoMonto;
END calcInteres;

CREATE OR REPLACE PROCEDURE updateDeposRet(
p_tasaInt IN Ahorros.tasa_int%TYPE
)
AS
CURSOR c_transac IS
SELECT tsdp.cod_sucursal, tsdp.monto, tsdp.id_cliente, tsdp.id_transaccion,
tsdp.tipoTransac, tsdp.id_typeAhorros
FROM transadeporti tsdp;
v_transac c_transac%ROWTYPE;
v_newMonto number;

BEGIN
    OPEN c_Transac;
    FETCH c_Transac INTO v_Transac;
    CLOSE c_Transac; 
    IF v_transac.tipoTransac = 1 THEN
            DBMS_OUTPUT.PUT_LINE('ye!');
        IF  v_transac.id_typeAhorros = 1 OR v_transac.id_typeAhorros = 3 THEN
            DBMS_OUTPUT.PUT_LINE('ye!');
            v_newMonto := calcInteres(p_tasaInt, v_transac.monto);
            UPDATE Ahorros
            SET saldo_ahorro = saldo_ahorro + (v_transac.monto - v_newMonto) , saldo_int = saldo_int - v_newMonto
            WHERE v_transac.id_cliente = ahorros.id_cliente
            AND v_transac.id_typeAhorros = ahorros.id_typeAhorros;
        ELSE
            UPDATE Ahorros
            SET saldo_ahorro = saldo_ahorro+v_transac.monto
            WHERE v_transac.id_cliente = ahorros.id_cliente
            AND v_transac.id_typeAhorros = ahorros.id_typeAhorros;
        END IF;
    ELSE
        IF v_transac.id_typeAhorros = 2 THEN
            UPDATE Ahorros
            SET saldo_Ahorro = saldo_Ahorro - v_transac.monto
            WHERE v_transac.id_cliente = ahorros.id_cliente
            AND v_transac.id_typeAhorros = ahorros.id_typeAhorros;
        END IF;
    END IF;
EXCEPTION 
    WHEN program_error THEN 
    dbms_output.put_line('Hubo un error en el PL/SQL. Vuelve a intentarlo.');
    WHEN dup_val_on_index THEN 
    DBMS_OUTPUT.PUT_LINE('Hubo un error de duplicación. Revisa los parametros.');
    WHEN OTHERS THEN
    DBMS_OUTPUT.PUT_LINE('Error desconocido.');
END updateDeposRet;


BEGIN
updateDeposRet(0.06);
updateDeposRet(0.05);
updateDeposRet(0.06);
END;

CREATE OR REPLACE TRIGGER updateSavings
AFTER UPDATE ON Ahorros
FOR EACH ROW
DECLARE 
    CURSOR c_auditCursor IS
    SELECT ts.id_transaccion,  ts.tipoTransac,
    ts.monto
    FROM transadeporti ts;
    v_Transac c_auditCursor%ROWTYPE;
BEGIN
    OPEN c_auditCursor;
    FETCH c_auditCursor INTO v_Transac;
    CLOSE c_auditCursor;
    IF :NEW.saldo_ahorro = :OLD.saldo_ahorro THEN
        DBMS_OUTPUT.PUT_LINE('Advertencia! No hubo cambios en la actualización. 
        Por favor verifique.');
        INSERT INTO Auditoria VALUES(v_transac.id_transaccion, :NEW.id_cliente, 
        :NEW.id_typeAhorros, v_Transac.tipoTransac, :OLD.saldo_ahorro, v_Transac.monto, :NEW.saldo_ahorro,
        USER, sysdate, 'Ahorros');
    ELSE
        INSERT INTO Auditoria VALUES(v_transac.id_transaccion, :NEW.id_cliente, 
        :NEW.id_typeAhorros, v_Transac.tipoTransac, :OLD.saldo_ahorro, v_Transac.monto, :NEW.saldo_ahorro,
        USER, sysdate, 'Ahorros');
    END IF;
END;

CREATE OR REPLACE TRIGGER updateSucursal
AFTER UPDATE ON Ahorros
REFERENCING OLD as old NEW as new
FOR EACH ROW
FOLLOWS updateSavings
DECLARE
    v_inTypeTransac transadeporti.tipoTransac%TYPE;
    v_codSucursal transadeporti.cod_sucursal%TYPE;
    v_SaldoF transadeporti.monto%TYPE;
BEGIN
    SELECT tipoTransac, cod_sucursal
    INTO v_inTypeTransac, v_codSucursal
    FROM Transadeporti
    WHERE :new.id_typeAhorros = transadeporti.id_typeAhorros AND
    :NEW.cod_sucursal = transadeporti.cod_sucursal;
    IF v_inTypeTransac = 1 THEN
        UPDATE SucursalTipoAhorro
        SET montoAhorro = montoAhorro + :new.saldo_Ahorro
        WHERE :new.cod_sucursal = v_codSucursal;
    ELSE
        UPDATE SucursalTipoAhorro
        SET montoAhorro = montoAhorro -:new.saldo_Ahorro
        WHERE  v_codSucursal = :new.cod_sucursal;
    END IF;
END;




CREATE OR REPLACE PROCEDURE payInterest
AS
CURSOR c_Interest IS
SELECT id_typeAhorros, num_cuenta, saldo_int,
id_cliente, tasa_int, saldo_ahorro
FROM Ahorros;
v_Interest c_Interest%ROWTYPE;
v_NewInterest number;
BEGIN
    OPEN c_Interest;
    FETCH c_Interest INTO v_Interest;
    CLOSE c_Interest;
    IF v_Interest.id_typeAhorros = 2 THEN
        IF v_Interest.saldo_ahorro > 0 THEN
            v_NewInterest := calcInteres(v_Interest.tasa_int, v_Interest.saldo_ahorro);
            UPDATE Ahorros
            SET saldo_ahorro = saldo_ahorro + v_NewInterest, saldo_int = saldo_int + v_NewInterest
            WHERE v_Interest.id_typeAhorros  =  2;
        ELSE
            DBMS_OUTPUT.PUT_LINE('Advertencia. no se puede completar el proceso de actualizaciónsaldo 0 o no existente.');
        END IF;
    END IF;
      
EXCEPTION 
    WHEN program_error THEN 
    dbms_output.put_line('Hubo un error en el PL/SQL. Vuelve a intentarlo.');
    WHEN dup_val_on_index THEN 
    DBMS_OUTPUT.PUT_LINE('Hubo un error de duplicación. Revisa los parametros.');
    WHEN OTHERS THEN
    DBMS_OUTPUT.PUT_LINE('Error desconocido.');
END payInterest;

BEGIN
payInterest();
payInterest();
END;
