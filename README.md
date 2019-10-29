Creates a kubeconfig with restricted rights from current kubeconfig

## Usage
Let's assume your cluster's kubeconfig is *./kubeconfig*.  
The following command will create a file *./new-kubeconfig* that restricts the user to rights specified in *role.yaml*.
These apply to namespace *development*, only. Access to other namespaces will be denied.

~~~
KUBECONFIG=./kubeconfig ./01-create-certificate.sh
KUBECONFIG=./kubeconfig ./02-create-kubeconfig.sh
~~~

Test with the following command:
~~~
KUBECONFIG=./new-kubeconfig kubectl get all -ndefault
~~~
You will get a list of error messages like
~~~
Error from server (Forbidden): replicationcontrollers is forbidden: User "andrew" cannot list resource "replicationcontrollers" in API group "" in the namespace "default"
~~~
