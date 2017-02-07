import pytest


@pytest.fixture
def nodes_ips(os_faults_steps):
    """Return dict node_fqdn -> node_ips."""
    nodes = os_faults_steps.get_nodes()
    ip_fqdn = {node.ip: node.fqdn for node in nodes}
    cmd = """ip -o a | awk '/scope global/{split($4,ip,"/"); print ip[1]}'"""
    results = os_faults_steps.execute_cmd(nodes, cmd)
    nodes_ips_ = {}
    for node_result in results:
        fqdn = ip_fqdn[node_result.host]
        nodes_ips_[fqdn] = node_result.payload['stdout_lines']

    return nodes_ips_