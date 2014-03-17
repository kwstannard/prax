require 'minitest'
require 'minitest/autorun'
require_relative '../libexec/file_usage_getter'

describe FileUsageGetter do
  let(:klass) { FileUsageGetter }
  let(:instance) { klass.new(file_name) }

  describe "#call" do
    let(:output) { instance.call }

    describe "the requested file does not exist" do
      let(:file_name) { "praxtest-badfile" }

      it "returns that the command isnt documented" do
        assert_match output, "Sorry, this command's usage isn't documented yet."
      end
    end

    describe "the requested file exists" do
      let(:file_name) { "praxtest-goodfile" }
      before do
        File.open(file_name, "w") do |f|
          f.write(<<-FILE)
# other stuff
#{usage_section}
# ipso
facto
fake Usage: foo
          FILE
        end
      end

      after { File.delete(file_name) }

      describe "when there is no usage" do
        let(:usage_section) { "" }

        it "returns that the command isnt documented" do
          assert_match output, "Sorry, this command's usage isn't documented yet."
        end
      end

      describe "when there is a usage section" do
        let(:usage_section) { "# Usage: foo" }

        it "returns that the command isnt documented" do
          assert_match output, "Usage: foo"
        end
      end
    end
  end
end
