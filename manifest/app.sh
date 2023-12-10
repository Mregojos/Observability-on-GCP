cat > app.yaml << EOF
apiVersion: apps/v1
kind: Deployment
metadata:
  name: app-deployment
  labels: 
    app: app
spec:
  replicas: 3
  selector: 
    matchLabels:
      app: app
  template:
    metadata: 
      labels:
        app: app
    spec:
      containers:
      - name: app
        image: $DOCKER_USERNAME/app:latest
        ports:
        - containerPort: 9000
        env:
        - name: DB_NAME
          value: '$DB_NAME'
        - name: DB_USER
          value: '$DB_USER'
        - name: DB_HOST
          value: '$DB_HOST'
        - name: DB_PORT
          value: '$DB_PORT'
        - name: DB_PASSWORD
          value: '$DB_PASSWORD'
        - name: PROJECT_NAME
          value: '$PROJECT_NAME'
        - name: ADMIN_PASSWORD
          value: '$ADMIN_PASSWORD'
        - name: APP_PORT
          value: '$APP_PORT'
        - name: APP_ADDRESS
          value: '$APP_ADDRESS'
        - name: DOMAIN_NAME
          value: '$DOMAIN_NAME'
        - name: SPECIAL_NAME
          value: '$SPECIAL_NAME'
EOF