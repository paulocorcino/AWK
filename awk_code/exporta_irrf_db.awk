BEGIN {
	FS = ">"; # o sistema ira quebrar as colunas a partir destes caracteres
	ln = -1; # ln - e uma variavel para contas o numero de linhas para o final do html da declaracao do funcionario
	html = ""; # variavel do html da delaracao do funcionario
	cap = 0; # indicador de quando deve comecar a armazenar a variavel html
}

{
 # Controle de Captura =============================================
 if(trim($0) == "<table width=\"720\" border=\"1\" cellpadding=\"0\" cellspacing=\"0\" bordercolor=\"#CCCCCC\">"){  # se localidar o codigo html correspondente indica onde inicia a declaracao do funcionario
	ln = -1; # ln -1 para informar que o nao deve executar operacoes  aabaixo o AWK ler todo o codigo deste arquivo em todas as linhas do documento
	cap = 1; # iniciar a captura do html vide linha 29 
 }
 
 if(ln >= 0){ # sistema deve iniciar a contagem de linhas pois está no final da declaracao
	ln = ln + 1;	# incrementa o numro de linhas lida
 }
 
 if(ln == 2){	# indica se o numero de linhas a partir do final da declaracao ele deve considerar o final
	cap = 2; # Cap é 2 informando que deve parar de capturar o html a declaracao encerrou agora mostre o codigo sql vide linha 41
 }
 
 if($0 ~ /Aprovado pela IN RFB/){ # se encontrar no html o termo descrito indica que estamos no final da declaracao
	ln = 0; # conforme liniha 15 o sistema comecara a contar as linhas para o final
 }
 # ====================================================================
 
 # Captura HTML =======================================================
  if(cap > 0){ # se cap maior que 0 o sistema comeca a capturar o html vide linha 12
	
	gsub("'"," ",$0); # troca aspa simples por espaco, agora esta linha e controversa se no html da declaracao utilizar aspas simples em codigo realmente nao pode ser utilizado esta linha deve ser substituido o espaco por um codigo mais adequado no momento nao sei qual :)
	
	if(html == ""){
		html = trim($0); # grava primeira linha
	} else {
		if(trim($0) != ""){ # se linha tem algo entao grava
			html = html " " trim($0);
		}
	}
	
	if(cap == 2){ # exibe resultado SQL
		# print "CPF", cpf;
		# print "MAT", mat;
		# print "CNPJ", cnpj;		
		# print html;
		printf("delete lhr_irrfdec where cpf = '%s');\n", cpf);
		printf("insert into lhr_irrfdec(cnpj,cpf,mat,declaracao) values ('%s','%s','%s','%s');\n", cnpj, cpf, mat, html);
		html = "";
		cpf  = "";
		mat  = "";
		cnpj = "";
		ano  = "";
		# print "/////////////////////////////////////////////////\n"
		cap = 0; # para captura
	}
	
  }
 # ======================================================================
 
 # CPF  =================================================================
 
	# Se na declaracao o cpf vier linhas apos ter sido encontrado o termo conforme a linha 66 o conteudo a partir da linha 71 a 76 deve ser colocado aqui.
 

	
	if($0 ~ /face=\"Arial, Helvetica, sans-serif\"><b>CPF<br><\/b>/){ # foi localizado o inicio do CPF no codigo
		lncpf = 1;
		
	}
	
	# se na declaracao o cpf vem na mesma linha onde foi encontrado o termo CPF conforme a linha 66 o conteudo de tratamento do html deve vir a partir daqui
	
	if(lncpf == 1 && trim($0) != ""){ 
		cpf = substr(trim($0),95,14);		
		gsub(/[\-\.]/,"",cpf);
		cpf = trim(cpf);
		lncpf = 0;
	}
	
	
	# esta logica e repetida nos proximos dados
 
 # ======================================================================
 # MATRICULA ============================================================
	

 
	 if($0 ~ /sans-serif\"><b>Matr&iacute;cula<\/b>/){
		lnmat = 1;
	 }
	 
	 if(lnmat == 1 && trim($0) != ""){
		mat = substr(trim($0),109,9);
		gsub("<\/div><\/td>","",mat);
		mat = trim(mat);
		lnmat = 0;
	}
 
 # =======================================================================
  # CNPJ ============================================================
	

 
	 if($0 ~ /sans-serif\"><b> CNPJ\/CPF<\/b><br>/){
		lncnpj = 1;
	 }
	 
	 if(lncnpj == 1 && trim($0) != ""){
		cnpj = substr(trim($0),101,19);
		gsub("<\/td>","",cnpj);
		gsub(/[\-\.\/]/,"",cnpj);
		cnpj = trim(cnpj);
		lncnpj = 0;
	}
 
 # =======================================================================
 
 
 
}
function ltrim(s) { sub(/^[ \t]+/, "", s); return s }
function rtrim(s) { sub(/[ \t]+$/, "", s); return s }
function trim(s)  { return rtrim(ltrim(s)); }