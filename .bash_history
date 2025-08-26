gcloud config set compute/zone us-east1-b
gsutil cp gs://spls/gsp051/continuous-deployment-on-kubernetes.zip .
unzip continuous-deployment-on-kubernetes.zip
cd continuous-deployment-on-kubernetes
gcloud container clusters create jenkins-cd --num-nodes 2 --machine-type e2-standard-2 --scopes "https://www.googleapis.com/auth/source.read_write,cloud-platform"
gcloud container clusters list
gcloud container clusters get-credentials jenkins-cd
kubectl cluster-info
helm repo add jenkins https://charts.jenkins.io
helm repo update
helm install cd jenkins/jenkins -f jenkins/values.yaml --wait
kubectl get pods
kubectl create clusterrolebinding jenkins-deploy --clusterrole=cluster-admin --serviceaccount=default:cd-jenkins
export POD_NAME=$(kubectl get pods --namespace default -l "app.kubernetes.io/component=jenkins-master" -l "app.kubernetes.io/instance=cd" -o jsonpath="{.items[0].metadata.name}")
kubectl port-forward $POD_NAME 8080:8080 >> /dev/null &
kubectl get svc
printf $(kubectl get secret cd-jenkins -o jsonpath="{.data.jenkins-admin-password}" | base64 --decode);echo
cd sample-app
kubectl create ns production
kubectl apply -f k8s/production -n production
kubectl apply -f k8s/canary -n production
kubectl apply -f k8s/services -n production
cd ..
export ZONE=us-east1-b
curl -LO raw.githubusercontent.com/Techcps/Google-Cloud-Skills-Boost/master/Continuous%20Delivery%20with%20Jenkins%20in%20Kubernetes%20Engine/techcps051.sh
sudo chmod +x techcps051.sh
./techcps051.sh
curl -LO raw.githubusercontent.com/Techcps/Google-Cloud-Skills-Boost/master/Continuous%20Delivery%20with%20Jenkins%20in%20Kubernetes%20Engine/techcps051.sh
sudo chmod +x techcps051.sh
./techcps051.sh
exit
export ZONE=us-east1-b
curl -LO raw.githubusercontent.com/Techcps/Google-Cloud-Skills-Boost/master/Continuous%20Delivery%20with%20Jenkins%20in%20Kubernetes%20Engine/techcps051.sh
sudo chmod +x techcps051.sh
./techcps051.sh
kubectl scale deployment gceme-frontend-production -n production --replicas 4
kubectl get pods -n production -l app=gceme -l role=frontend
kubectl get pods -n production -l app=gceme -l role=backend
kubectl get service gceme-frontend -n production
export FRONTEND_SERVICE_IP=$(kubectl get -o jsonpath="{.status.loadBalancer.ingress[0].ip}" --namespace=production services gceme-frontend)
curl http://$FRONTEND_SERVICE_IP/version
curl -sS https://webi.sh/gh | sh
gh auth login
gh api user -q ".login"
GITHUB_USERNAME=$(gh api user -q ".login")
git config --global user.name "${GITHUB_USERNAME}"
git config --global user.email "${USER_EMAIL}"
echo ${GITHUB_USERNAME}
echo ${USER_EMAIL}
gh repo create default --private 
git init
git config credential.helper gcloud.sh
git remote add origin https://github.com/${GITHUB_USERNAME}/default
