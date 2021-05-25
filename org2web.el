(defvar org-index-header
"\#+HTML_HEAD: <link rel=\"stylesheet\" type=\"text/css\" href=\"https://gongzhitaao.org/orgcss/org.css\"/>
\#+OPTIONS: toc:nil

")

(defun org-index-description (d)
  (if (file-exists-p (concat (expand-file-name d) "/about.org"))
    (with-temp-buffer
      (insert-file-contents (concat (expand-file-name d) "/about.org"))
      (buffer-string))
    (concat "* " (first (last (split-string (expand-file-name d) "/"))))))

(defvar org-index-files-header
  (concat"
" "** Topics
"))

(defvar org-index-dirs-header
  (concat"
" "** Sub Topics
"))

(defun org-create-index-file ()
 (interactive)
 (let ((root ".")
      (abspath nil)
      (match nil)
      (nosort t))
      (let ((content (remove "." 
                  (remove ".." 
                          (directory-files root abspath match nosort)))))
      (let ((files (seq-filter 
                 (lambda (x) (file-directory-p (expand-file-name x root)))
                  content))
      (dirs  (seq-filter 
                 (lambda (x) (file-regular-p (expand-file-name x root)))
                  content)))
                  (let ((file-template (mapconcat 'create-file-template files ""))
                       (dir-template (mapconcat 'create-dir-template dirs "")))
                    (write-region 
                       (concat org-index-header (org-index-description ".")
                       org-index-dirs-header dir-template 
                       org-index-files-header file-template)
                       nil "index.org"))))))
