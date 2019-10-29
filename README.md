Creates a kubconfig with restricted rights from current kubeconfig

## Usage
Let's assume your cluster's kubeconfig is *./kubeconfig*.  
The following command will create a file *./new-kubeconfig* that restricts the user to rights specified in *role.yaml*.
These apply to namespace *development*, only. Access to other namespaces will be denied.

~~~
KUBECONFIG=./kubeconfig 01-create-certificate.sh
KUBECONFIG=./kubeconfig 02-create-kubeconfig.sh
~~~
