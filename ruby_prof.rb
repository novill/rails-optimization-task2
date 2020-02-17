# ruby-prof
# dot -Tpng graphviz.dot > graphviz.png

require 'ruby-prof'
require_relative 'bad_work.rb'

RubyProf.measure_mode = RubyProf::ALLOCATIONS

result = RubyProf.profile do
  work('data1000.txt', disable_gc: true)
end

printer = RubyProf::FlatPrinter.new(result)
f = File.open('ruby_prof_reports/flat.txt', 'w+')
printer.print(f)
f.close

printer = RubyProf::DotPrinter.new(result)
printer.print(File.open('ruby_prof_reports/graphviz.dot', 'w+'))

printer = RubyProf::GraphHtmlPrinter.new(result)
printer.print(File.open('ruby_prof_reports/graph.html', 'w+'))

printer = RubyProf::CallStackPrinter.new(result)
printer.print(File.open('ruby_prof_reports/callstack.html', 'w+'))
