# Esperimento su dataset e compilatori

Richiedendo token su hf si accede a stack, da leggere bene la licenza
X-cobol e rosetta opensource.

## Cob2Py - resoconto

I file utilizzati per la conversione sono file molto semplici, quasi sempre in Free format (50 su 69 totali)
[] Da vedere i file non in free format

mentre i file utilizzati in rosetta, stack e x-cobol sono quasi tutti in altri formati (e.g. formato libero. solo 5 Free su 5584)

``` bash
total=$(find . -type f \( -iname "*.cob" -o -iname "*.cbl" -o -iname "*.cpy" \) | wc -l); 
free=$(find . -type f \( -iname "*.cob" -o -iname "*.cbl" -o -iname "*.cpy" \) -exec grep -iEl 'SOURCEFORMAT\s*"?FREE"?' {} + | wc -l); 
echo "FREE: $free / TOTAL: $total"
```

### Note sul funzionamento
Via ssh è utilizzabile con tkinter e da client con -Y o -X nel comando ssh, va abilitato il forwarding X11 sui /etc/ssh/ssh_config

## cobol2java

Il codice utilizza java 8.0 (verificare), quindi va avviato o in vm o mediante SDKMAN!

```
openjdk 17.0.18 2026-01-20
OpenJDK Runtime Environment (build 17.0.18+8-Ubuntu-124.04.1)
OpenJDK 64-Bit Server VM (build 17.0.18+8-Ubuntu-124.04.1, mixed mode, sharing)
```