data "kubectl_path_documents" "manifests" {
    pattern = "./manifests/ssm-agent.yaml"
}

resource "kubectl_manifest" "ssm-agent" {
    count     = length(data.kubectl_path_documents.manifests.documents)
    yaml_body = element(data.kubectl_path_documents.manifests.documents, count.index)
}