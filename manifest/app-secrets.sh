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
          valueFrom:
            secretKeyRef: 
              name: my-secret
              key: DB_NAME
        - name: DB_USER
          valueFrom:
            secretKeyRef: 
              name: my-secret
              key: DB_USER
        - name: DB_HOST
          valueFrom:
            secretKeyRef: 
              name: my-secret
              key: DB_HOST
        - name: DB_PORT
          valueFrom:
            secretKeyRef: 
              name: my-secret
              key: DB_PORT
        - name: DB_PASSWORD
          valueFrom:
            secretKeyRef: 
              name: my-secret
              key: DB_PASSWORD
        - name: PROJECT_NAME
          valueFrom:
            secretKeyRef: 
              name: my-secret
              key: PROJECT_NAME
        - name: ADMIN_PASSWORD
          valueFrom:
            secretKeyRef: 
              name: my-secret
              key: ADMIN_PASSWORD
        - name: APP_PORT
          valueFrom:
            secretKeyRef: 
              name: my-secret
              key: APP_PORT
        - name: APP_ADDRESS
          valueFrom:
            secretKeyRef: 
              name: my-secret
              key: APP_ADDRESS
        - name: DOMAIN_NAME
          valueFrom:
            secretKeyRef: 
              name: my-secret
              key: DOMAIN_NAME
        - name: SPECIAL_NAME
          valueFrom:
            secretKeyRef: 
              name: my-secret
              key: SPECIAL_NAME
    
EOF

kubectl delete secret my-secret -n app
kubectl create secret generic my-secret --from-literal=DB_NAME=$DB_NAME --from-literal=DB_USER=$DB_USER --from-literal=DB_HOST=$DB_HOST --from-literal=DB_PORT=$DB_PORT  \
    --from-literal=DB_PASSWORD=$DB_PASSWORD --from-literal=PROJECT_NAME=$PROJECT_NAME --from-literal=ADMIN_PASSWORD=$ADMIN_PASSWORD \
    --from-literal=APP_PORT=$APP_PORT --from-literal=APP_ADDRESS=$APP_ADDRESS --from-literal=DOMAIN_NAME=$DOMAIN_NAME --from-literal=SPECIAL_NAME=$SPECIAL_NAME \
    --type=Opaque \
    -n app
# kubectl get secret my-secret -o yaml -n app > my-secret.yaml

