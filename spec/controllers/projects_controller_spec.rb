require 'rails_helper'

RSpec.describe ProjectsController, type: :controller do
    describe "#index" do
        # 認証済みのユーザとして
        context "as an authenticated user" do
            before do
                @user = FactoryBot.create(:user)
            end

            # 正常にレスポンスを返すこと
            it "responds successfully" do
                sign_in @user
                get :index
                expect(response).to be_successful
            end

            # 200レスポンスを返すこと
            it "returns a 200 reponse" do
                sign_in @user
                get :index
                expect(response).to have_http_status "200"
            end
        end

        # ゲストとして
        context "as a guest" do
            # 302レスポンスを返すこと
            it "returns a 302 response" do
                get :index
                expect(response).to have_http_status "302"
            end

            #サインイン画面にリダイレクトすること
            it "redirects to the sign-in page" do
                get :index
                expect(response).to redirect_to "/users/sign_in"
            end
        end
    end

    describe "#show" do
        #認可されたユーザとして
        context "as an authorized user" do
            before do
                @user = FactoryBot.create(:user)
                @project = FactoryBot.create(:project, owner: @user)
            end

            # 正常にレスポンスを返すこと
            it "responds successfully" do
                sign_in @user
                get :show,params: { id: @project.id }
                expect(response).to be_successful
            end
        end

        # 認可されていないユーザとして
        context "as an unauthorized user" do
            before do
                @user = FactoryBot.create(:user)
                other_user = FactoryBot.create(:user)
                @project = FactoryBot.create(:project, owner: other_user)
            end

            #ダッシュボードにリダイレクトすること
            it "redirects to the dashborad" do
                sign_in @user
                get :show, params: { id: @project.id }
                expect(response).to redirect_to root_path
            end
        end
    end
end