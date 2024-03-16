-- Listar medidas
CREATE PROCEDURE USP_LISTADO_ME
AS
	SELECT DESCRIPCION_ME,
			CODIGO_ME
	FROM TB_MEDIDAS
	WHERE ACTIVO = 1
GO;

-- Listar Categorias
CREATE PROCEDURE USP_LISTADO_CA
AS
	SELECT DESCRIPCION_CA,
			CODIGO_CA
	FROM TB_CATEGORIAS
	WHERE ACTIVO = 1
GO;

-- Listar Productos
CREATE PROCEDURE USP_LISTADO_PR
@cTexto varchar(80)=''
AS
	SELECT p.codigo_pr,
		   p.descripcion_pr,
		   p.marca_pr,
		   m.descripcion_me,
		   c.descripcion_ca,
		   p.stock_actual,
		   p.codigo_me,
		   p.codigo_ca
	FROM TB_PRODUCTOS p
	INNER JOIN TB_MEDIDAS m ON p.codigo_me=m.codigo_me
	INNER JOIN TB_CATEGORIAS c ON p.codigo_ca=c.codigo_ca
	WHERE p.activo = 1
	AND UPPER(TRIM(p.descripcion_pr + p.marca_pr)) LIKE '%'+UPPER(TRIM(@cTexto))+'%'
	ORDER BY p.codigo_pr;
GO;

-- Guardar productos
CREATE PROCEDURE USP_GUARDAR_PR
@Opcion int=1, -- 1=Nuevo Registro / 2=Actualizar Registro
@nCodigo_pr int,
@cDescripcion_pr varchar(80),
@cMarca_pr varchar(30),
@nCodigo_me int,
@nCodigo_ca int,
@nStock_actual numeric(18,2)
AS
if @Opcion=1 --Nuevo Registro
	begin
		INSERT INTO TB_PRODUCTOS(descripcion_pr,
								 marca_pr,
								 codigo_me,
								 codigo_ca,
								 stock_actual,
								 fecha_crea,
								 activo)
						  VALUES(@cDescripcion_pr,
								 @cMarca_pr,
								 @nCodigo_me,
								 @nCodigo_ca,
								 @nStock_actual,
								 GETDATE(),
								 1);
	end;
else --Actualizar Registro
	begin
		UPDATE TB_PRODUCTOS SET descripcion_pr=@cDescripcion_pr,
								marca_pr=@cMarca_pr,
								codigo_me=@nCodigo_me,
								codigo_ca=@nCodigo_ca,
								stock_actual=@nStock_actual
						  WHERE codigo_pr=@nCodigo_pr;
	end;
GO;

-- Activar producto
CREATE PROCEDURE ACTIVO_PR
@nCodigo_pr int,
@bEstado_activo bit
AS
	UPDATE TB_PRODUCTOS SET activo=@bEstado_activo
					  WHERE codigo_pr=@nCodigo_pr;
GO

-- 