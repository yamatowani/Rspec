require 'rails_helper'

RSpec.describe Project, type: :model do
   #ユーザ単位では重複したプロジェクトを許可しない
   it "does not allow duplicate project names per user" do
    user = FactoryBot.create(:user)
    user.projects.create(
      name: "Test Project",
    )

    new_project = user.projects.build(
      name: "Test Project",
    )

    new_project.valid?
    expect(new_project.errors[:name]).to include("has already been taken")
   end

   #二人のユーザが同じ名前をつけることは許可すること
   it "allows two users to share a project name" do
    user = FactoryBot.create(:user)

    user.projects.create(
      name: "Test Project",
    )

    other_user = User.create(
      first_name: "Jane",
      last_name:  "Tester",
      email:      "janetester@example.com",
      password:   "dottle-nouveau-pavilion-tights-furze",
    )

    other_project = other_user.projects.build(
      name: "Test Project",
    )

    expect(other_project).to be_valid
   end

   it "is valid with name" do
    user = FactoryBot.create(:user)

    project = user.projects.create(
      name: "Test Project",
      )
    expect(project).to be_valid
   end
end

# 遅延ステータス
describe "late status" do
  # 締切日が過ぎていれば遅延していること
  it "is late when the due date is past today" do
    project = FactoryBot.create(:project, :due_yesterday)
    expect(project).to be_late
  end

  #締切日が今日ならスケジュール通りであること
  it "is on time when the due date is today" do
    project = FactoryBot.create(:project, :due_today)
    expect(project).to_not be_late
  end

  # 締切日が未来ならスケジュール通りであること
  it "is on time when the due date is in the future" do
    project = FactoryBot.create(:project, :due_tomorrow)
    expect(project).to_not be_late
  end

  # たくさんのメモが付いていること
  it "can have mane notes" do
    project = FactoryBot.create(:project, :with_notes)
    expect(project.notes.length).to eq 5 
  end
end
