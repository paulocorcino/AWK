BEGIN {
    ln = -1;
    cap = 0;
    id = "";

    print "id;empresa"
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

    if(index($0, ":") > 0 && cap >= 1) {
        raw = trim($0);

        split(raw, d, ":")

        key = trim(d[1])
        value = trim(d[2])

        # Get ID
        if(key == "ID") {
            id = value;
        }  
    }

    if($0 ~ /Tipo de impressão/ && cap == 2) {
        cap = 1;
    }

    if(ln >= 3 && cap == 2 && trim($0) != "" && $0 ~ /[[:digit:]][[:digit:]]\/[[:digit:]][[:digit:]]/) {
        
        # Acessos
        raw = trim($0);

        p1 = substr(raw, 1, 63);
        p2 = substr(raw, 64, 127);

        gsub(/              /," ",p1);
        gsub(/              /," ",p2);
        
        # print id, trim(p1)
         printf("%s;\"%s\"\n", id, trim(p1));

        if(p2 != "") {
          # print id, trim(p2)   
          printf("%s;\"%s\"\n", id, trim(p2));
        }
    }

    if(cap == 1) {

        if($0 ~ /Cod\/Fil/) {
            cap = 2;
            ln = 0;
        }

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
  
}