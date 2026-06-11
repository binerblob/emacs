(use-package indent-bars
  :ensure t
  :custom
  (indent-bars-starting-column 0)
  (indent-bars-no-descend-lists 'skip) ; prevent extra bars in nested lists + skip intermediate bars
  (indent-bars-treesit-support -1)
  (indent-bars-treesit-ignore-blank-lines-types '("module"))
  ;; Add other languages as needed; check the wiki
  (indent-bars-treesit-scope '((python function_definition class_definition for_statement
	  if_statement with_statement while_statement)))
  ;; Note: wrap likely not be needed if no-descend-list is enough
  ;;(indent-bars-treesit-wrap '((python argument_list parameters ; for python, as an example
  ;;				      list list_comprehension
  ;;				      dictionary dictionary_comprehension
  ;;				      parenthesized_expression subscript)))
  :hook ((prog-mode) . indent-bars-mode))
