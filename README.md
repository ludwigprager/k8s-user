Creates a kubconfig with restricted rights from current kubeconfig

## short cut in your .bashrc
Let's assume your cluster's kubeconfig is *./kubeconfig*.
The following command will create a file *./new-kubeconfig* that restricts the user to rights specified in *role.yaml*.
These apply to namespace *development*, only. No access is possible to other namespaces.

~~~
KUBECONFIG=./kubeconfig 01-create-certificate.sh
KUBECONFIG=./kubeconfig 02-create-kubeconfig.sh
~~~
