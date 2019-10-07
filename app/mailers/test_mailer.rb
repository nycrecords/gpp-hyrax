class TestMailer < ApplicationMailer
  def test_email
    mail(
        from: "jyu@records.nyc.gov",
        to: "jyu@records.nyc.gov",
        subject: "Test mail",
        body: "Test mail body"
    )
  end
end