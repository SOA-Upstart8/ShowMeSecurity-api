release: rake db:migrate; rake queues:create
worker: RACK_ENV=production bundle exec shoryuken -r ./workers/filiter_worker.rb -C ./workers/shoryuken.yml
web: bundle exec puma -t 5:5 -p ${PORT:-3000} -e ${RACK_ENV:-development}
