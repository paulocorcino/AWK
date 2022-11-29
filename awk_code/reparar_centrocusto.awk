BEGIN {
	ln = 0;
}
{
	
	if(ln >= 1){
		ln = ln + 1;
	}
	
	if($0 ~ /----Centro de Custo---/){ # centro de custo
		tabela = "func_ccusto";
		
		ln = 1;
	}
	
	if($0 ~ /-----MDO----/){ # mao de obra
		tabela = "func_tip_mdo";
		
		ln = 1;
	}
	
	if($0 ~ /---Unidade Negoc---/){ # unidade negocio
		tabela = "func_estab_unid_negoc";
		
		ln = 1;
	}
	
	if($0 ~ /----Agente Nocivo---/){ # agente nocisvo
		tabela = "func_expos_agent_nociv";
		
		ln = 1;
	}
		
	
	if(ln > 4){
				
		emp       = $1;	
		estab     = $2; 	
		mat       = $3;
		dataini   = substr($0,19,10);	
		datafim   = substr($0,30,10);	
		datafimok = substr($0,41,10);
        error     = trim(substr($0,53,90));		
		
	
		# INICIO ERRADO ===============================================================
		if(trim(error) ~ /Data Inicio do Historico Errada/){
			#print emp, estab, mat, dataini, datafim, datafimok, error;	
			printf("FIND FIRST " tabela " WHERE " tabela ".cdn_empresa = '%s' \n\t AND " tabela ".cdn_estab = '%s' \n\t AND " tabela ".cdn_funcionario = %s \n\t AND " tabela ".dat_fim_lotac_func = date(\"%s\") \n\t AND " tabela ".dat_inic_lotac_func = date(\"%s\") NO-ERROR.\n", emp, estab, mat, datafim, dataini);
			printf("if avail " tabela " then assign " tabela ".dat_inic_lotac_func = date(\"%s\").\n\n ", datafimok);
		}
		
		# FIM ERRADO ===============================================================
		if(trim(error) ~ /Data Fim do Historico Errada/){
			#print emp, estab, mat, dataini, datafim, datafimok, error;	
			printf("FIND FIRST " tabela " WHERE " tabela ".cdn_empresa = '%s' \n\t AND " tabela ".cdn_estab = '%s' \n\t AND " tabela ".cdn_funcionario = %s \n\t AND " tabela ".dat_fim_lotac_func = date(\"%s\") \n\t AND " tabela ".dat_inic_lotac_func = date(\"%s\") NO-ERROR.\n", emp, estab, mat, datafim, dataini);
			printf("if avail " tabela " then assign " tabela ".dat_fim_lotac_func = date(\"%s\").\n\n ", datafimok);
		}
		
		# DUPLICADO ================================================================
		if(trim(error) ~ /Dois Historicos Com a Mesma Data Ini\/Fim/){
			#print emp, estab, mat, dataini, datafim, datafimok, error;	
			printf("FIND FIRST " tabela " WHERE " tabela ".cdn_empresa = '%s' \n\t AND " tabela ".cdn_estab = '%s' \n\t AND " tabela ".cdn_funcionario = %s \n\t AND " tabela ".dat_fim_lotac_func = date(\"%s\") \n\t AND " tabela ".dat_inic_lotac_func = date(\"%s\") NO-ERROR.\n", emp, estab, mat, datafim, dataini);
			printf("if avail " tabela " then delete " tabela ".\n\n ");
		}
		
		# INICIO MAIOR QUE O FINAL ===============================================================          
		if(trim(error) ~ /Data Fim Menor que a Data Inicio/){
			#print emp, estab, mat, dataini, datafim, datafimok, error;	
			printf("FIND FIRST " tabela " WHERE " tabela ".cdn_empresa = '%s' \n\t AND " tabela ".cdn_estab = '%s' \n\t AND " tabela ".cdn_funcionario = %s \n\t AND " tabela ".dat_fim_lotac_func = date(\"%s\") \n\t AND " tabela ".dat_inic_lotac_func = date(\"%s\") NO-ERROR.\n", emp, estab, mat, datafim, dataini);
			printf("if avail " tabela " then assign " tabela ".dat_fim_lotac_func = date(\"31\/12\/9999\").\n\n ");
		}
		
		# FIM ERRADO ===============================================================
		if(trim(error) ~ /Data Fim do Historico Errada (Compl)/){
			#print emp, estab, mat, dataini, datafim, datafimok, error;	
			printf("FIND FIRST " tabela " WHERE " tabela ".cdn_empresa = '%s' \n\t AND " tabela ".cdn_estab = '%s' \n\t AND " tabela ".cdn_funcionario = %s \n\t AND " tabela ".dat_fim_lotac_func = date(\"%s\") \n\t AND " tabela ".dat_inic_lotac_func = date(\"%s\") NO-ERROR.\n", emp, estab, mat, datafim, dataini);
			printf("if avail " tabela " then assign " tabela ".dat_fim_lotac_func = date(\"%s\").\n\n ", datafimok);
		}
		
		
		
		
	}

}
function ltrim(s) { sub(/^[ \t]+/, "", s); return s }
function rtrim(s) { sub(/[ \t]+$/, "", s); return s }
function trim(s)  { return rtrim(ltrim(s)); }