(comment) @comment

;; Github actions ("run") / Gitlab CI ("scripts")
(block_mapping_pair
  key: (flow_node) @_run (#any-of? @_run "run" "script" "before_script" "after_script")
  value: (flow_node
           (plain_scalar) @bash))

(block_mapping_pair
  key: (flow_node) @_run (#any-of? @_run "run" "script" "before_script" "after_script")
  value: (block_node
           (block_scalar) @bash (#offset! @bash 0 1 0 0)))

(block_mapping_pair
  key: (flow_node) @_run (#any-of? @_run "run" "script" "before_script" "after_script")
  value: (block_node
           (block_sequence
             (block_sequence_item
               (flow_node) @bash))))

(block_mapping_pair
  key: (flow_node) @_run (#any-of? @_run "script" "before_script" "after_script")
  value: (block_node
           (block_sequence
             (block_sequence_item
               (block_node
                  (block_scalar) @bash (#offset! @bash 0 1 0 0))))))

;; Prometheus Alertmanager ("expr")
(block_mapping_pair
  key: (flow_node) @_expr (#eq? @_expr "expr")
  value: (flow_node
           (plain_scalar) @promql))

(block_mapping_pair
  key: (flow_node) @_expr (#eq? @_expr "expr")
  value: (block_node
           (block_scalar) @promql (#offset! @promql 0 2 0 0)))

(block_mapping_pair
  key: (flow_node) @_expr (#eq? @_expr "expr")
  value: (block_node
           (block_sequence
             (block_sequence_item
               (flow_node) @promql))))

(block_mapping_pair
  key: (flow_node) @_expr (#eq? @_expr "expr")
  value: (block_node
           (block_sequence
             (block_sequence_item
               (block_node
                  (block_scalar) @promql (#offset! @promql 0 2 0 0))))))
