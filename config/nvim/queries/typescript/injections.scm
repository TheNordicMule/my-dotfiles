; extends
  (call_expression
    function: (member_expression
      object: (_)
      property: (property_identifier) @_raw
    )
    arguments: (arguments
      (template_string
        (string_fragment) @injection.content
        (#set! injection.language "sql")
        (#set! injection.include-children)
      )
    )
   (#eq? @_raw "raw")
  )
