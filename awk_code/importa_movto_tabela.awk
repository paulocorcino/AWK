BEGIN {
	FS = ";";
	ln = 0;
}
{

 if(ln > 0 && $1 != ""){
 
	split(substr($1,1,10), sptDate, "/");
	dta = sprintf("%s%s%s", sptDate[3], sptDate[2], sptDate[1]);
	printf("insert into dbo.ESG_CHAVE_TABELA values ('OPERACIO','%s','%s','DIA')\n", toupper($2), dta);
	printf("insert into dbo.ESG_VALORES_TABELA(CAMPOS,TABELA_ABREV,ESTRUTURA_ABREV,PERIODO_DT,TABELA_PERIOCIDADE,META,VALOR) values ('GLOSA','OPERACIO','%s','%s','DIA',NULL,%s)\n",  toupper($2), dta, financ($3) );
	printf("insert into dbo.ESG_VALORES_TABELA(CAMPOS,TABELA_ABREV,ESTRUTURA_ABREV,PERIODO_DT,TABELA_PERIOCIDADE,META,VALOR) values ('REPARO','OPERACIO','%s','%s','DIA',NULL,%s)\n", toupper($2), dta, financ($4) );
	printf("insert into dbo.ESG_VALORES_TABELA(CAMPOS,TABELA_ABREV,ESTRUTURA_ABREV,PERIODO_DT,TABELA_PERIOCIDADE,META,VALOR) values ('EXCDTM','OPERACIO','%s','%s','DIA',NULL,%s)\n", toupper($2), dta, financ($5) );
	printf("insert into dbo.ESG_VALORES_TABELA(CAMPOS,TABELA_ABREV,ESTRUTURA_ABREV,PERIODO_DT,TABELA_PERIOCIDADE,META,VALOR) values ('FALTAS','OPERACIO','%s','%s','DIA',NULL,%s)\n", toupper($2), dta, financ($6) );
	printf("insert into dbo.ESG_VALORES_TABELA(CAMPOS,TABELA_ABREV,ESTRUTURA_ABREV,PERIODO_DT,TABELA_PERIOCIDADE,META,VALOR) values ('DIESEL','OPERACIO','%s','%s','DIA',NULL,%s)\n", toupper($2), dta, financ($7) );
	
  }
  
  ln = ln + 1;
}
function ltrim(s) { sub(/^[ \t]+/, "", s); return s }
function rtrim(s) { sub(/[ \t]+$/, "", s); return s }
function trim(s)  { return rtrim(ltrim(s)); }
function financ(vlr){
	gsub(/[()]/, "", vlr);
	gsub(/\./, "", vlr);
	
	vlr = trim(vlr)
	if(vlr == "")
		return 0;
		
	if(vlr ~ /,/){			
		split(vlr, dec, ",");
		cent = ""
		
		if(dec[2] != "") 
			cent = "." dec[2];
		
		decim = dec[1];		
		
		if(decim ~ /\./) 
			gsub(/\./, "", decim);
			
		return decim "" cent;
	}
	
	return vlr;
}
