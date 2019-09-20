class TestMailer < ApplicationMailer
  def test_email
    mail(
        from: "donotreply@records.nyc.gov",
        to: "jyu@records.nyc.gov",
        subject: "Test mail",
        body: "Test mail body"
    )
  end
end