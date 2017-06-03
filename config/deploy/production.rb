# coding: utf-8
# frozen_string_literal: true

set :rails_env, 'production'
server '119.29.178.236', user: 'deployer', roles: %w[web app db]
