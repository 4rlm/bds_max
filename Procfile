web:            bundle exec rails server -p $PORT
worker:         bundle exec foreman start -f Procfile.workers
puma:           tail -f log/development.log


# redis:          bundle exec redis-server /usr/local/etc/redis.conf
# sidekiq:        bundle exec sidekiq -C config/sidekiq.yml
# worker:         bundle exec sidekiq -q default -c 2
# worker: bundle exec foreman start -f Procfile.workers
# sidekiq:        RAILS_MAX_THREADS=${SIDEKIQ_RAILS_MAX_THREADS:-15} bundle exec sidekiq -C config/sidekiq.yml
