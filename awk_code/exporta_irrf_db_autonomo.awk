BEGIN {
	FS = ";";
	ln = -1;
	html = "";
	cap = 0;
}
{
 # Controle de Captura =============================================
 if(trim($0) ~ /MINISTERIO DA FAZENDA/){
	ln = -1;
	cap = 1; # inicia captira	
 }
 
 if(ln >= 0){
	ln = ln + 1;	
 }
 
 if(ln == 3){	
	cap = 2; # ultima linha
 }
 
 if($0 ~ /Aprovado pela IN RFB/){
	ln = 0;
 }
 # ====================================================================
 
 # Captura HTML =======================================================
  if(cap > 0){
  
	gsub("'"," ",$0);
	
	if(html == ""){
		html = "+---------------------------------------------------------------------------------------------+\n" $0;		
	} else {
		if(trim($0) != ""){			
			html = html "\n" $0;
		}
	}
	
	if(cap == 2){
		#print "CPF", cpf;
		#print "MAT", "0";
		#print "CNPJ", cnpj;		
		#print html;
		printf("insert into lhr_irrfdec(cnpj,cpf,mat,declaracao) values ('%s','%s','%s','<pre>%s</pre><br><br>');\n", cnpj, cpf, "0", html);
		html = "";
		cpf  = "";
		mat  = "";
		cnpj = "";
		ano  = "";
		
		cap = 0; # para captura
	}
	
  }
 # ======================================================================
 
 # CPF  =================================================================
 
	if(lncpf == 1){
		cpf = substr(trim($0),1,17);		
		gsub(/[\-\.\/\|]/,"",cpf);
		cpf = trim(cpf);
		lncpf = 0;
	}
	
	if($0 ~ /CPF            NOME COMPLETO/){
		lncpf = 1;		
	}
 
 # ======================================================================
  # CNPJ ============================================================
	
	if(lncnpj == 1){
		cnpj = substr(trim($0),1,27);
		gsub(/[\-\.\/\|]/,"",cnpj);
		cnpj = trim(cnpj);
		lncnpj = 0;
	}
 
	 if($0 ~ /CNPJ\/CPF\:/){
		lncnpj = 1;
	 }
 
 # =======================================================================
 
 
 
}
function ltrim(s) { sub(/^[ \t]+/, "", s); return s }
function rtrim(s) { sub(/[ \t]+$/, "", s); return s }
function trim(s)  { return rtrim(ltrim(s)); }