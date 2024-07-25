output "aurora_cluster_endpoint" {
  description = "The endpoint of the Aurora cluster"
  value       = aws_rds_cluster.aurora_cluster.endpoint
}

output "aurora_cluster_reader_endpoint" {
  description = "The reader endpoint of the Aurora cluster"
  value       = aws_rds_cluster.aurora_cluster.reader_endpoint
}

output "aurora_master_instance_id" {
  description = "The ID of the master instance"
  value       = aws_rds_cluster_instance.aurora_master.id
}

output "aurora_read_replica_instance_ids" {
  description = "The IDs of the read replica instances"
  value       = [for replica in aws_rds_cluster_instance.aurora_read_replica : replica.id]
}
