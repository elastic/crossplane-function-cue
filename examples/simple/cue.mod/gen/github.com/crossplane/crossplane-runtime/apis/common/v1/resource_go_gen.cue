// Code generated by cue get go. DO NOT EDIT.

//cue:generate cue get go github.com/crossplane/crossplane-runtime/apis/common/v1

package v1

import (
	"k8s.io/apimachinery/pkg/types"
	corev1 "k8s.io/api/core/v1"
)

// ResourceCredentialsSecretEndpointKey is the key inside a connection secret for the connection endpoint
#ResourceCredentialsSecretEndpointKey: "endpoint"

// ResourceCredentialsSecretPortKey is the key inside a connection secret for the connection port
#ResourceCredentialsSecretPortKey: "port"

// ResourceCredentialsSecretUserKey is the key inside a connection secret for the connection user
#ResourceCredentialsSecretUserKey: "username"

// ResourceCredentialsSecretPasswordKey is the key inside a connection secret for the connection password
#ResourceCredentialsSecretPasswordKey: "password"

// ResourceCredentialsSecretCAKey is the key inside a connection secret for the server CA certificate
#ResourceCredentialsSecretCAKey: "clusterCA"

// ResourceCredentialsSecretClientCertKey is the key inside a connection secret for the client certificate
#ResourceCredentialsSecretClientCertKey: "clientCert"

// ResourceCredentialsSecretClientKeyKey is the key inside a connection secret for the client key
#ResourceCredentialsSecretClientKeyKey: "clientKey"

// ResourceCredentialsSecretTokenKey is the key inside a connection secret for the bearer token value
#ResourceCredentialsSecretTokenKey: "token"

// ResourceCredentialsSecretKubeconfigKey is the key inside a connection secret for the raw kubeconfig yaml
#ResourceCredentialsSecretKubeconfigKey: "kubeconfig"

#LabelKeyProviderName: "crossplane.io/provider-config"

// A LocalSecretReference is a reference to a secret in the same namespace as
// the referencer.
#LocalSecretReference: {
	// Name of the secret.
	name: string @go(Name)
}

// A SecretReference is a reference to a secret in an arbitrary namespace.
#SecretReference: {
	// Name of the secret.
	name: string @go(Name)

	// Namespace of the secret.
	namespace: string @go(Namespace)
}

// A SecretKeySelector is a reference to a secret key in an arbitrary namespace.
#SecretKeySelector: {
	#SecretReference

	// The key to select.
	key: string @go(Key)
}

// Policy represents the Resolve and Resolution policies of Reference instance.
#Policy: {
	// Resolve specifies when this reference should be resolved. The default
	// is 'IfNotPresent', which will attempt to resolve the reference only when
	// the corresponding field is not present. Use 'Always' to resolve the
	// reference on every reconcile.
	// +optional
	// +kubebuilder:validation:Enum=Always;IfNotPresent
	resolve?: null | #ResolvePolicy @go(Resolve,*ResolvePolicy)

	// Resolution specifies whether resolution of this reference is required.
	// The default is 'Required', which means the reconcile will fail if the
	// reference cannot be resolved. 'Optional' means this reference will be
	// a no-op if it cannot be resolved.
	// +optional
	// +kubebuilder:default=Required
	// +kubebuilder:validation:Enum=Required;Optional
	resolution?: null | #ResolutionPolicy @go(Resolution,*ResolutionPolicy)
}

// A Reference to a named object.
#Reference: {
	// Name of the referenced object.
	name: string @go(Name)

	// Policies for referencing.
	// +optional
	policy?: null | #Policy @go(Policy,*Policy)
}

// A TypedReference refers to an object by Name, Kind, and APIVersion. It is
// commonly used to reference cluster-scoped objects or objects where the
// namespace is already known.
#TypedReference: {
	// APIVersion of the referenced object.
	apiVersion: string @go(APIVersion)

	// Kind of the referenced object.
	kind: string @go(Kind)

	// Name of the referenced object.
	name: string @go(Name)

	// UID of the referenced object.
	// +optional
	uid?: types.#UID @go(UID)
}

// A Selector selects an object.
#Selector: {
	// MatchLabels ensures an object with matching labels is selected.
	matchLabels?: {[string]: string} @go(MatchLabels,map[string]string)

	// MatchControllerRef ensures an object with the same controller reference
	// as the selecting object is selected.
	matchControllerRef?: null | bool @go(MatchControllerRef,*bool)

	// Policies for selection.
	// +optional
	policy?: null | #Policy @go(Policy,*Policy)
}

// A ResourceSpec defines the desired state of a managed resource.
#ResourceSpec: {
	// WriteConnectionSecretToReference specifies the namespace and name of a
	// Secret to which any connection details for this managed resource should
	// be written. Connection details frequently include the endpoint, username,
	// and password required to connect to the managed resource.
	// This field is planned to be replaced in a future release in favor of
	// PublishConnectionDetailsTo. Currently, both could be set independently
	// and connection details would be published to both without affecting
	// each other.
	// +optional
	writeConnectionSecretToRef?: null | #SecretReference @go(WriteConnectionSecretToReference,*SecretReference)

	// PublishConnectionDetailsTo specifies the connection secret config which
	// contains a name, metadata and a reference to secret store config to
	// which any connection details for this managed resource should be written.
	// Connection details frequently include the endpoint, username,
	// and password required to connect to the managed resource.
	// +optional
	publishConnectionDetailsTo?: null | #PublishConnectionDetailsTo @go(PublishConnectionDetailsTo,*PublishConnectionDetailsTo)

	// ProviderConfigReference specifies how the provider that will be used to
	// create, observe, update, and delete this managed resource should be
	// configured.
	// +kubebuilder:default={"name": "default"}
	providerConfigRef?: null | #Reference @go(ProviderConfigReference,*Reference)

	// THIS IS A BETA FIELD. It is on by default but can be opted out
	// through a Crossplane feature flag.
	// ManagementPolicies specify the array of actions Crossplane is allowed to
	// take on the managed and external resources.
	// This field is planned to replace the DeletionPolicy field in a future
	// release. Currently, both could be set independently and non-default
	// values would be honored if the feature flag is enabled. If both are
	// custom, the DeletionPolicy field will be ignored.
	// See the design doc for more information: https://github.com/crossplane/crossplane/blob/499895a25d1a1a0ba1604944ef98ac7a1a71f197/design/design-doc-observe-only-resources.md?plain=1#L223
	// and this one: https://github.com/crossplane/crossplane/blob/444267e84783136daa93568b364a5f01228cacbe/design/one-pager-ignore-changes.md
	// +optional
	// +kubebuilder:default={"*"}
	managementPolicies?: #ManagementPolicies @go(ManagementPolicies)

	// DeletionPolicy specifies what will happen to the underlying external
	// when this managed resource is deleted - either "Delete" or "Orphan" the
	// external resource.
	// This field is planned to be deprecated in favor of the ManagementPolicies
	// field in a future release. Currently, both could be set independently and
	// non-default values would be honored if the feature flag is enabled.
	// See the design doc for more information: https://github.com/crossplane/crossplane/blob/499895a25d1a1a0ba1604944ef98ac7a1a71f197/design/design-doc-observe-only-resources.md?plain=1#L223
	// +optional
	// +kubebuilder:default=Delete
	deletionPolicy?: #DeletionPolicy @go(DeletionPolicy)
}

// ResourceStatus represents the observed state of a managed resource.
#ResourceStatus: {
	#ConditionedStatus
}

// A CredentialsSource is a source from which provider credentials may be
// acquired.
#CredentialsSource: string // #enumCredentialsSource

#enumCredentialsSource:
	#CredentialsSourceNone |
	#CredentialsSourceSecret |
	#CredentialsSourceInjectedIdentity |
	#CredentialsSourceEnvironment |
	#CredentialsSourceFilesystem

// CredentialsSourceNone indicates that a provider does not require
// credentials.
#CredentialsSourceNone: #CredentialsSource & "None"

// CredentialsSourceSecret indicates that a provider should acquire
// credentials from a secret.
#CredentialsSourceSecret: #CredentialsSource & "Secret"

// CredentialsSourceInjectedIdentity indicates that a provider should use
// credentials via its (pod's) identity; i.e. via IRSA for AWS,
// Workload Identity for GCP, Pod Identity for Azure, or in-cluster
// authentication for the Kubernetes API.
#CredentialsSourceInjectedIdentity: #CredentialsSource & "InjectedIdentity"

// CredentialsSourceEnvironment indicates that a provider should acquire
// credentials from an environment variable.
#CredentialsSourceEnvironment: #CredentialsSource & "Environment"

// CredentialsSourceFilesystem indicates that a provider should acquire
// credentials from the filesystem.
#CredentialsSourceFilesystem: #CredentialsSource & "Filesystem"

// CommonCredentialSelectors provides common selectors for extracting
// credentials.
#CommonCredentialSelectors: {
	// Fs is a reference to a filesystem location that contains credentials that
	// must be used to connect to the provider.
	// +optional
	fs?: null | #FsSelector @go(Fs,*FsSelector)

	// Env is a reference to an environment variable that contains credentials
	// that must be used to connect to the provider.
	// +optional
	env?: null | #EnvSelector @go(Env,*EnvSelector)

	// A SecretRef is a reference to a secret key that contains the credentials
	// that must be used to connect to the provider.
	// +optional
	secretRef?: null | #SecretKeySelector @go(SecretRef,*SecretKeySelector)
}

// EnvSelector selects an environment variable.
#EnvSelector: {
	// Name is the name of an environment variable.
	name: string @go(Name)
}

// FsSelector selects a filesystem location.
#FsSelector: {
	// Path is a filesystem path.
	path: string @go(Path)
}

// A ProviderConfigStatus defines the observed status of a ProviderConfig.
#ProviderConfigStatus: {
	#ConditionedStatus

	// Users of this provider configuration.
	users?: int64 @go(Users)
}

// A ProviderConfigUsage is a record that a particular managed resource is using
// a particular provider configuration.
#ProviderConfigUsage: {
	// ProviderConfigReference to the provider config being used.
	providerConfigRef: #Reference @go(ProviderConfigReference)

	// ResourceReference to the managed resource using the provider config.
	resourceRef: #TypedReference @go(ResourceReference)
}

// A TargetSpec defines the common fields of objects used for exposing
// infrastructure to workloads that can be scheduled to.
//
// Deprecated.
#TargetSpec: {
	// WriteConnectionSecretToReference specifies the name of a Secret, in the
	// same namespace as this target, to which any connection details for this
	// target should be written or already exist. Connection secrets referenced
	// by a target should contain information for connecting to a resource that
	// allows for scheduling of workloads.
	// +optional
	connectionSecretRef?: null | #LocalSecretReference @go(WriteConnectionSecretToReference,*LocalSecretReference)

	// A ResourceReference specifies an existing managed resource, in any
	// namespace, which this target should attempt to propagate a connection
	// secret from.
	// +optional
	clusterRef?: null | corev1.#ObjectReference @go(ResourceReference,*corev1.ObjectReference)
}

// A TargetStatus defines the observed status a target.
//
// Deprecated.
#TargetStatus: {
	#ConditionedStatus
}
