BEGIN {
    ln = -1;
    cap = 0;
    id = "";
}

{
    # capture start ======================================
    if($0 ~ /\*\* Grupo \*\*/){ # start user info
	    ln = 0; 
        cap = 1;        
    }

    if($0 ~ /Data da inclusão/){ # end use info
	    ln = -1; 
        cap = 0;
    }

    if($0 ~ /LGRL[[:digit:]][[:digit:]]\.BMP/) { # pause capture
        cap = 0;
    }

    #get group info
    if(index($0, ":") > 0 && cap == 1) {
        raw = trim($0);

        split(raw, d, ":")

        key = trim(d[1])
        value = trim(d[2])

        # Get ID
        if(key == "ID") {
            id = value;
        }  
        
        # get data user

        # print id, key, value

        if(key == "Nome") 
            nome_grupo[id] = value;

        if(key ~ /Qtde de dias para expirar a senha/) 
            dias_expirar[id] = value;
        
        if(key ~ /Empresas/) 
            empresas_acesso[id] = value;      

    }

    # Count line

    if(ln >= 0){ 
	    ln = ln + 1;
    }

    if($0 ~ /Hora\.\.\.\:/ && cap == 0 && ln > 0) { # start capture
        cap = 1; 
    }

}

# function trim
function ltrim(s) { sub(/^[ \t]+/, "", s); return s }
function rtrim(s) { sub(/[ \t]+$/, "", s); return s }
function trim(s)  { return rtrim(ltrim(s)); }

END {
    print "grupoid;grupo;dias_expirar;acesso_empresas;"
    for (id in nome_grupo) {
        	printf("\"%s\";%s;%s;%s;\n", id, nome_grupo[id], dias_expirar[id], empresas_acesso[id]);
    }
}