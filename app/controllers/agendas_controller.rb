class AgendasController < ApplicationController
  # before_action :set_agenda, only: %i[show edit update destroy]

  def index
    @agendas = Agenda.all
  end

  def new
    @team = Team.friendly.find(params[:team_id])
    @agenda = Agenda.new
  end

  def create
    @agenda = current_user.agendas.build(title: params[:title])
    @agenda.team = Team.friendly.find(params[:team_id])
    current_user.keep_team_id = @agenda.team.id
    if current_user.save && @agenda.save
      redirect_to dashboard_url, notice: 'アジェンダ作成に成功しました！'
    else
      render :new
    end
  end

  def destroy
    @agenda = Agenda.find(params[:id])
    @agenda.destroy
    @agenda.team.members.each do |member|
      AssignMailer.remove_agenda_mail(member.email, @agenda.title).deliver
    end
    redirect_to dashboard_url, notice: 'アジェンダ削除に成功しました！'
  end

  private

  def set_agenda
    @agenda = Agenda.find(params[:id])
  end

  def agenda_params
    params.fetch(:agenda, {}).permit %i[title description]
  end

  #def agenda_destroy(agenda, agenda_user)
    #if agenda_user == agenda.user_id
      #agenda.destroy
      #'アジェンダを削除しました！'
    #elsif
      #'このユーザーは権限を所有していないため、削除できません。'
    #else
      #'なんらかの原因で、削除できませんでした。'
    #end
  #end
end
