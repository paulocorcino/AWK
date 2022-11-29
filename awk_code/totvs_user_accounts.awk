BEGIN {
    ln = -1;
    cap = 0;
    id = "";
}

{
    # capture start ======================================
    if($0 ~ /\*\* Usuário \*\*/){ # start user info
	    ln = 0; 
        cap = 1;        
    }

    if($0 ~ /Restrição de Acessos/){ # end use info
	    ln = -1; 
        cap = 0;
    }

    if($0 ~ /LGRL[[:digit:]][[:digit:]]\.BMP/) { # pause capture
        cap = 0;
    }

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
            nome_abrev[id] = value;

        if(key ~ /Nome Completo/) 
            nome_completo[id] = value;
        
        if(key ~ /Data de Validade/) 
            data_validade[id] = value;

        if(key ~ /Autorizado a alterar a senha/) 
            ies_altera_senha[id] = value;

        if(key ~ /Alterar a senha no próximo Logon/) 
            ies_altera_senha_prox_logon[id] = value;

        if(key ~ /Supervisor/) 
            id_supervisor[id] = value;

        if(key ~ /Departamento/) 
            departamento[id] = value;

        if(key ~ /Cargo/)
            cargo[id] = value;

        if(key ~ /Funcionário/)
            funcionario[id] = value;

        if(key ~ /E-mail/)
            email[id] = value;

        if(key ~ /Número de acessos simultâneos/)
            acesso_simultaneo[id] = value;

        if(key ~ /Data da inclusão/)
            data_inclusao[id] = value;

        if(key ~ /Data da última alteração/)
            data_ultima_alteracao[id] = value;

        if(key ~ /Usuário bloqueado/)
            usuario_bloqueado[id] = value;

        if(key ~ /Número de digitos para o ano/)
            numero_num_dig_ano[id] = value;

        if(key ~ /Diretório de relatório/)
            dir_relatorio[id] = value;

        if(key ~ /Ambiente/)
            ambiente[id] = value;

        if(key == "Grupo(s)")
            grupos[id] = value;

        if(key == "Empresas")
            empresas[id] = value;

    }

    # Count line

    if(ln >= 0){ 
	    ln = ln + 1;
    }

    if($0 ~ /Hora\.\.\.\:/ && cap == 0 && ln > 0) { # start capture
        cap = 1; 
    }

}

function ltrim(s) { sub(/^[ \t]+/, "", s); return s }
function rtrim(s) { sub(/[ \t]+$/, "", s); return s }
function trim(s)  { return rtrim(ltrim(s)); }

END {
    print "id;nome_abrev;nome_completo;data_validade;ies_altera_senha;ies_altera_senha_prox_logon;id_supervisor;departamento;cargo;funcionario;email;acesso_simultaneo;data_inclusao;data_ultima_alteracao;usuario_bloqueado;numero_num_dig_ano;ambiente;grupos;empresas"
    for (id in nome_abrev) {
        	printf("\"%s\";%s;%s;%s;%s;%s;%s;%s;%s;%s;%s;%s;%s;%s;%s;%s;%s;%s;%s\n", id, nome_abrev[id], nome_completo[id], data_validade[id], ies_altera_senha[id],  ies_altera_senha_prox_logon[id], id_supervisor[id], departamento[id],  cargo[id], funcionario[id], email[id], acesso_simultaneo[id], data_inclusao[id], data_ultima_alteracao[id], usuario_bloqueado[id], numero_num_dig_ano[id], ambiente[id], grupos[id], empresas[id]);
    }
}