require "spec_helper"

describe MyBcycle do
  it "has a version number" do
    expect(MyBcycle::VERSION).not_to be nil
  end
  let(:valid_user) do
    MyBcycle::User.new(
      username: ENV.fetch("BCYCLE_TEST_USER"),
      password: ENV.fetch("BCYCLE_TEST_PASS")
    )
  end

  context "User provides valid credentials" do
    it "can fetch statistics" do
      VCR.use_cassette("happy_path", record: :once) do
        stats = valid_user.statistics_for(Time.parse("2016-05-01"))
        expect(stats).to eq(Time.parse("2001-01-01 01:01:01.01Z") => {
                              miles: 999.80,
                              duration: 22,
                              money_saved: 1.5,
                            })
      end
    end
  end
  context "When credentials are invalid" do
    it "Raises InvalidCredentials Exception" do
      VCR.use_cassette("invalid_cred", record: :once) do
        user = MyBcycle::User.new(
          username: "not",
          password: "valid"
        )
        expect do
          user.statistics_for(Time.parse("2016-05-01"))
        end.to raise_error(MyBcycle::InvalidCredentials)
      end
    end
  end

  context "Unexpected communication problems" do
    context "when getting 500 error" do
      it "raises appropriate exception" do
        stub_request(:any, /authenticate/i)
          .to_return(status: [500, "Internal Server Error"])
        expect do
          valid_user.statistics_for(Time.parse("2016-05-01"))
        end.to raise_error(MyBcycle::CommunicationProblem)
      end
    end
  end
end
