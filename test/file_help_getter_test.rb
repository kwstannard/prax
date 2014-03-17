require 'minitest'
require 'minitest/autorun'
require_relative '../libexec/file_help_getter'

describe FileHelpGetter do
  let(:klass) { FileHelpGetter }
  let(:instance) { klass.new(file_name) }

  describe "#call" do
    let(:output) { instance.call }

    describe "the requested file does not exist" do
      let(:file_name) { "/tmp/praxtest-badfile" }

      it "returns that the command isnt documented" do
        assert_equal "", output
      end
    end

    describe "the requested file exists" do
      let(:file_name) { "/tmp/praxtest-goodfile" }

      before do
        File.open(file_name, "w") do |f|
          f.write(<<-FILE)
# other stuff
#{help_section}
ipso
facto
          FILE
        end
      end

      after { File.delete(file_name) }

      describe "when there is no help" do
        let(:help_section) { "" }

        it "returns that the command isnt documented" do
          assert_equal "", output
        end
      end

      describe "when there is a help section" do
        let(:help_section) { "# Help: foo\n#\n# bar\n# baz" }

        it "returns the help section" do
          assert_equal "foo\n\nbar\nbaz", output
        end
      end
    end
  end
end
