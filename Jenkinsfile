@Library('web-service-helper-lib') _

pipeline {
  agent any

  options {
    timestamps()
    ansiColor('xterm')
  }

  environment {
    // Customize these if you like
	DOCKER_IMAGE_NAME = 'ghcr.io/e-learning-by-sse/nm-self-learn-docs'
    DOCKER_VERSION  = "1.0.${env.BUILD_NUMBER}"
  }

  stages {
    stage('Prepare') {
      steps {
        sh '''
          set -e
          rm -rf "$WORKSPACE/build"
          mkdir -p "$WORKSPACE/build"
        '''
      }
    }

    stage('Build docs: de') {
      steps {
        sh '''
          set -e
          docker run --rm \
            -v "$WORKSPACE/docs:/docs" \
            -v "$WORKSPACE/build:/build" \
            sphinxdoc/sphinx \
            sphinx-build -b html /docs/de/source /build/de
        '''
      }
    }

    stage('Build docs: en') {
      steps {
        sh '''
          set -e
          docker run --rm \
            -v "$WORKSPACE/docs:/docs" \
            -v "$WORKSPACE/build:/build" \
            sphinxdoc/sphinx \
            sphinx-build -b html /docs/en/source /build/en
        '''
      }
    }

    stage('Build Docker and publish') {
		steps {
			script {
				ssedocker {
					create {
						target "${DOCKER_IMAGE_NAME}:${DOCKER_VERSION}"
					}
					publish {
						tag "latest"
					}
				}
			}
		}
    }
  }

  post {
    success {
      echo "Docs built into $WORKSPACE/build (de & en). Image: ${DOCKER_IMAGE_NAME}:${DOCKER_VERSION}"
    }
    failure {
      echo 'Pipeline failed. Check the stage logs above.'
    }
  }
}
