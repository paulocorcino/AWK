{
	# printf "INSERT INTO LOGIX.LOG_GRUPOS "
	# printf "VALUES ('%sfolus', 'EMP:%s SET:FOLHA NIV:US', '%s', 'M');\n", $1, $1, $1 

	# printf "INSERT INTO LOGIX.LOG_GRUPOS " 
	# printf "VALUES ('%sfolco', 'EMP:%s SET:FOLHA NIV:CO', '%s', 'M');\n", $1, $1, $1 
	
	printf "INSERT INTO LOGIX.PAR_RHU (COD_EMPRESA, VAL_BASE_GREMIO, IES_LOGIX_CON, IES_LOGIX_CARGOS, IES_LOGIX_PLANO, QTD_HORAS_MES, IES_CALC_INSAL, IES_TIPO_MODULO, VAL_CALC_DIG, FORMA_CONTABILIZ, QTD_MESES_EXAME, COD_MOEDA_UFIR, COD_MOEDA_JAM_3, COD_MOEDA_JAM_6, COD_MOEDA_FAJ_TR, COD_MOEDA_DOLAR, COD_MOEDA_CORRENTE, COD_TEXTO_AUM_GER, COD_TEXTO_AUM_ESP, IES_ESTRUTURA, SUBDIR_ARQ_MAG)"
	printf " VALUES ('%s', NULL, 'S', 'N', 'N', 220, 'N', NULL, 1, 'S', 1, 1, 1, 1, 1, 1, 1, NULL, NULL, 'R', NULL);\n", $1
}