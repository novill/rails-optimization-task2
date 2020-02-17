# Stackprof ObjectAllocations and Flamegraph
#
# Text:
# stackprof stackprof.dump
# stackprof stackprof.dump --method Object#work
#
# Graphviz:
# stackprof --graphviz stackprof_reports/stackprof.dump > graphviz.dot
# dot -Tpng graphviz.dot > graphviz.png
# imgcat graphviz.png

require 'stackprof'
require_relative 'work.rb'

# Note mode: :object
StackProf.run(mode: :object, out: 'stackprof_reports/stackprof.dump', raw: true) do
  work('data1500000.txt', disable_gc: false)
end
