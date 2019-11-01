Creates a kubeconfig with restricted rights from current kubeconfig.

## Usage
Let's assume your cluster's kubeconfig is *./kubeconfig*.  
The following command will create a file *./new-kubeconfig* that restricts the user to the rights specified in *role.yaml*.
These apply to namespace *development*, only. Access to other namespaces will be denied.

~~~
KUBECONFIG=./kubeconfig ./create-user.sh
~~~

Test with the following command:
~~~
KUBECONFIG=./new-kubeconfig kubectl get all -ndefault
~~~
You will get a list of error messages like
~~~
Error from server (Forbidden): replicationcontrollers is forbidden: User "andrew" cannot list resource "replicationcontrollers" in API group "" in the namespace "default"
~~~

whereas a command like the following will succeed:
~~~
KUBECONFIG=./new-kubeconfig kubectl get pod -ndevelopment
~~~
