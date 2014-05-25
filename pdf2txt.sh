#!/bin/sh
STARTPAGE=1 # set to pagenumber of the first page of PDF you wish to convert
RESOLUTION=300 # set to the resolution the scanner used (the higher, the better)

dumphelp(){
        echo "sudo $0   "
        echo "language (optional): default eng, other possible "
        echo "ara (Arabic), aze (Azerbauijani), bul (Bulgarian), cat (Catalan),$
       (Czech), chi_sim (Simplified Chinese), chi_tra (Traditional Chinese),
       chr (Cherokee), dan (Danish), dan-frak (Danish (Fraktur)), deu
       (German), ell (Greek), eng (English), enm (Old English), epo
       (Esperanto), est (Estonian), fin (Finnish), fra (French), frm (Old
       French), glg (Galician), heb (Hebrew), hin (Hindi), hrv (Croation), hun
       (Hungarian), ind (Indonesian), ita (Italian), jpn (Japanese), kor
       (Korean), lav (Latvian), lit (Lithuanian), nld (Dutch), nor
       (Norwegian), pol (Polish), por (Portuguese), ron (Romanian), rus
       (Russian), slk (Slovakian), slv (Slovenian), sqi (Albanian), spa
       (Spanish), srp (Serbian), swe (Swedish), tam (Tamil), tel (Telugu), tgl
       (Tagalog), tha (Thai), tur (Turkish), ukr (Ukrainian), vie (Vietnamese)"
        exit 1
}

if [ $# -lt 2 ]; then
        dumphelp
fi

SOURCE=$1 # set to the file name of the PDF
OUTPUT=$2 #set to the final output file
FOLDER=$(echo -n $1 | grep -o "[0-9]*")
FOLDER="/home/ubuntu/scripts/$FOLDER"
mkdir $FOLDER
LANGUAGE="eng"

if [ $# -eq 3 ]; then
LANGUAGE=$3
fi

ENDPAGE=`pdfinfo $SOURCE | grep Pages | sed 's/ //g' | cut -d':' -f2`
echo $STARTPAGE $ENDPAGE

touch $OUTPUT
for i in `seq $STARTPAGE $ENDPAGE`; do
    convert -monochrome -density $RESOLUTION $SOURCE\[$(($i - 1 ))\] $FOLDER/page.tif
    echo processing page $i
    tesseract -l $LANGUAGE $FOLDER/page.tif $FOLDER/tempoutput
    cat $FOLDER/tempoutput.txt >> $OUTPUT
done

rm -r $FOLDER
rm $1