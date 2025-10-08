pipeline {
  agent any

  options {
    timestamps()
    ansiColor('xterm')
  }

  environment {
    // Customize these if you like
    DOCKER_IMAGE_NAME = 'my-app'
    DOCKER_IMAGE_TAG  = "${env.BUILD_NUMBER}"
  }

  stages {
    stage('Prepare build folder') {
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

    stage('Build Docker image from Dockerfile') {
      steps {
        sh '''
          set -e
          docker build -t "${DOCKER_IMAGE_NAME}:${DOCKER_IMAGE_TAG}" .
          echo "Built image: ${DOCKER_IMAGE_NAME}:${DOCKER_IMAGE_TAG}"
        '''
      }
    }
  }

  post {
    success {
      echo "Docs built into $WORKSPACE/build (de & en). Image: ${DOCKER_IMAGE_NAME}:${DOCKER_IMAGE_TAG}"
    }
    failure {
      echo 'Pipeline failed. Check the stage logs above.'
    }
  }
}
