FactoryBot.define do
  factory :workflow_run do
    token { create(:workflow_token) }
    request_headers do
      <<~END_OF_HEADERS
        HTTP_X_GITHUB_EVENT: pull_request
      END_OF_HEADERS
    end
    request_payload do
      File.read('spec/support/files/request_payload_github_pull_request_opened.json')
    end
  end

  # GitHub
  factory :workflow_run_github, parent: :workflow_run do
    factory :workflow_run_github_succeeded do
      status { 'success' }
      response_url { 'https://api.github.com' }
      response_body do
        <<~END_OF_RESPONSE_BODY
          <status code="ok">
            <summary>Ok</summary>
          </status>
        END_OF_RESPONSE_BODY
      end
      trait :pull_request_opened do
        request_payload do
          File.read('spec/support/files/request_payload_github_pull_request_opened.json')
        end
      end
      trait :pull_request_closed do
        request_payload do
          File.read('spec/support/files/request_payload_github_pull_request_closed.json')
        end
      end
      trait :push do
        request_headers do
          <<~END_OF_HEADERS
            HTTP_X_GITHUB_EVENT: push
          END_OF_HEADERS
        end
        request_payload do
          File.read('spec/support/files/request_payload_github_push.json')
        end
      end
      trait :tag_push do
        request_headers do
          <<~END_OF_HEADERS
            HTTP_X_GITHUB_EVENT: push
          END_OF_HEADERS
        end
        request_payload do
          File.read('spec/support/files/request_payload_github_tag_push.json')
        end
      end
    end

    factory :workflow_run_github_running do
      status { 'running' }
      response_body { nil }
      response_url { nil }
    end

    factory :workflow_run_github_failed do
      status { 'fail' }
      response_body do
        <<~END_OF_RESPONSE_BODY
          <status code="unknown">
            <summary>The 'target_project' key is missing</summary>
          </status>
        END_OF_RESPONSE_BODY
      end
    end
  end

  # GitLab
  factory :workflow_run_gitlab, parent: :workflow_run do
    request_headers do
      <<~END_OF_HEADERS
        HTTP_X_GITLAB_EVENT: Merge Request Hook
      END_OF_HEADERS
    end
    request_payload do
      File.read('spec/support/files/request_payload_gitlab_pull_request_opened.json')
    end

    factory :workflow_run_gitlab_succeeded do
      status { 'success' }
      response_url { 'https://gitlab.com' }
      response_body do
        <<~END_OF_RESPONSE_BODY
          <status code="ok">
            <summary>Ok</summary>
          </status>
        END_OF_RESPONSE_BODY
      end
      trait :pull_request_opened do
        request_payload do
          File.read('spec/support/files/request_payload_gitlab_pull_request_opened.json')
        end
      end
      trait :pull_request_closed do
        request_payload do
          File.read('spec/support/files/request_payload_gitlab_pull_request_closed.json')
        end
      end
      trait :push do
        request_headers do
          <<~END_OF_HEADERS
            HTTP_X_GITLAB_EVENT: Push Hook
          END_OF_HEADERS
        end
        request_payload do
          File.read('spec/support/files/request_payload_gitlab_push.json')
        end
      end
      trait :tag_push do
        request_headers do
          <<~END_OF_HEADERS
            HTTP_X_GITLAB_EVENT: Tag Push Hook
          END_OF_HEADERS
        end
        request_payload do
          File.read('spec/support/files/request_payload_gitlab_tag_push.json')
        end
      end
    end

    factory :workflow_run_gitlab_running do
      status { 'running' }
      response_body { nil }
      response_url { nil }
    end

    factory :workflow_run_gitlab_failed do
      status { 'fail' }
      response_body do
        <<~END_OF_RESPONSE_BODY
          <status code="unknown">
            <summary>The 'target_project' key is missing</summary>
          </status>
        END_OF_RESPONSE_BODY
      end
    end
  end
end