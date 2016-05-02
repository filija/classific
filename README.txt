- Autori: Jakub Filipek (xfilip34), Filip Denk (xdenkf00)

- adresar SRC obsahuje 2 skripty (rozpoznani podle hlasu a podle fotky) napsane v jazyce MATLAB
- pouzili jsme 2 externi knihovny:
	1. funkce poskytnute pro vyuku IKR (slozka SRC/lib)
	2. VLFeat - rozpoznavani obrazu (slozka SRC/vlfeat-0.9.20), ke stazeni na http://www.vlfeat.org/
- vysledkem jsou 2 soubory: result_audio.txt a result_image.txt v korenovem adresari odevzdaneho zipu
- vysledky ziskame pouhym spustenim souboru speech.m a img.m v MATLABU (v adresari SRC/)

- skripty byly uspesne otestovany na serveru merlin
- problem, ktery muze nastat u jine verze matlabu se tyka nacitani audia (funkce wavread -> audioread)