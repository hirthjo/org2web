SOURCE=/home/git/orglife/org-content/
TARGET=/home/git/orglife/export_html

for d in $(find $SOURCE -type d);
do
  echo "created index file for: " $d
  echo " "
  cd $d
  emacsclient -e '(progn (org-create-index-file))'
done

cd ${SOURCE}
for f in $(find $SOURCE -name '*.org');
do
  echo "exported: "${f}
  fdir=$TARGET/${f#${SOURCE}}
  echo "to: "
  emacsclient -e  '(progn (find-file "'${f}'") 
                           (global-auto-revert-mode t)
                           (setq html-export-dir "'${fdir%/*}'")
                           (org-html-export-to-html))'   
  echo " "
done
