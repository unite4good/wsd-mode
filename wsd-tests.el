(require 'ert)
(require 'wsd-core)

;; test-helpers

(when (not (fboundp 'string-suffix-p))
  (defun string-suffix-p (str1 str2 &optional ignore-case)
    (let ((begin2 (- (length str2) (length str1)))
          (end2 (length str2)))
      (when (< begin2 0) (setq begin2 0))
      (eq t (compare-strings str1 nil nil
                             str2 begin2 end2
                             ignore-case)))))

(setq file-names '(nil "lalalala" "test.txt" "test.wsd" "test.a.wsd"))

(ert-deftest local-filename-is-never-nil ()
  (dolist (file-name file-names)
    (let* ((image-name (wsd-get-image-filename file-name)))
      (should
       (not (equal nil image-name))))))

(ert-deftest local-filename-always-contains-extension ()
  (dolist (file-name file-names)
    (let* ((image-name (wsd-get-image-filename file-name)))
      (should
       (string-suffix-p wsd-format image-name)))))

(setq wsd-test-img "?png=mscb9q07p")
(setq wsd-test-json-img `((actualWidth . 529.516) (naturalWidth . 529.516) (errors . []) (img . ,wsd-test-img)))

(setq wsd-test-error "Line 20: Deactivate: User was not activated.")
(setq wsd-test-json-error `((actualWidth . 531.016) (naturalWidth . 531.016) (errors . [,wsd-test-error]) (img . "?png=mscpFx2np")))

(ert-deftest image-urls-are-detected ()
  (let* ((image-url (wsd-get-image-url wsd-test-json-img)))
    (should
     (string-suffix-p wsd-test-img image-url))))

(ert-deftest errors-are-detected ()
  (let* ((errors (wsd-get-errors wsd-test-json-error)))
    (should
     (equal (list wsd-test-error) errors))))

;; (ert-deftest errors-are-interpeted ()
;;   (let* ((error-list  (wsd-get-errors wsd-test-json-error))
;;          (error-items (wsd-get-error-lines error-list))
;;          (first-error (car error-items)))
;;     (should (= 1 (length error-items)))

;;     (should (= 20 (car first-error)))
;;     (should (= "Deactivate: User was not activated." (cdr first-error)))))

;;(ert-run-tests-interactively t)
