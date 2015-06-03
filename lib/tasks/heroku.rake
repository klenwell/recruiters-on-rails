namespace :heroku do

  desc 'Test task: heroku run rake heroku:test["hello world"]'
  task :test, [:str] do |t, args|
    puts format('heroku test task with args: %s', args)
  end

  desc 'Reset database with seed data'
  task :reset_db do |t, args|
    abort("Abort: task only for Heroku environment.") unless ENV['RESET_DATABASE'] == 'ok'

    run_command("pg:reset DATABASE_URL --confirm #{ENV['APP_NAME']}", ENV['APP_NAME'])
    run_command("run rake db:setup", ENV['APP_NAME'])
    run_command("run rake db:seed", ENV['APP_NAME'])
  end

  # Helper Functions
  # Source: http://kakimotonline.com/2014/04/27/using-rake-to-automate-heroku-tasks/
  def run_command(cmd, app_name)
    Bundler.with_clean_env do
      sh build_command(cmd, app_name)
    end
  end

  def run_command_with_output(cmd, app_name)
    Bundler.with_clean_env do
      `#{build_command(cmd, app_name)}`
    end.gsub("\n", "")
  end

  def build_command(cmd, app_name)
    "heroku #{cmd} --app #{app_name}"
  end
end
