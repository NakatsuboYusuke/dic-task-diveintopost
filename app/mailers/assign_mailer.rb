class AssignMailer < ApplicationMailer
  default from: 'from@example.com'

  def assign_mail(email, password)
    @email = email
    @password = password
    mail to: @email, subject: '登録完了'
  end

  def transfer_mail(email, team)
    @email = email
    @team = team
    mail to: @email, subject: "#{@team}チームのリーダー権限があなたに移動しました！"
  end
end
