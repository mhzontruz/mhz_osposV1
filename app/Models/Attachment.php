<?php

namespace App\Models;

use CodeIgniter\Model;

class Attachment extends Model
{
    protected $table = 'attachments';
    protected $primaryKey = 'attachment_id';
    protected $useAutoIncrement = true;
    protected $returnType = 'array';
    protected $useTimestamps = true;
    protected $allowedFields = [
        'entity_type',
        'entity_id',
        'attachment_type',
        'file_name',
        'mime_type',
        'file_size',
        'file_data',
        'is_primary',
    ];

    public function getPrimaryImage(string $entityType, int $entityId): ?array
    {
        return $this->where('entity_type', $entityType)
            ->where('entity_id', $entityId)
            ->where('attachment_type', 'image')
            ->where('is_primary', 1)
            ->first();
    }

    public function getPrimaryImageById(int $attachmentId): ?array
    {
        return $this->where('attachment_id', $attachmentId)
            ->where('attachment_type', 'image')
            ->where('is_primary', 1)
            ->first();
    }

    public function savePrimaryImage(string $entityType, int $entityId, array $image): int|false
    {
        $current = $this->getPrimaryImage($entityType, $entityId);
        $data = [
            'entity_type'     => $entityType,
            'entity_id'       => $entityId,
            'attachment_type' => 'image',
            'file_name'       => $image['file_name'],
            'mime_type'       => $image['mime_type'],
            'file_size'       => $image['file_size'],
            'file_data'       => $image['file_data'],
            'is_primary'      => 1,
        ];

        if ($current !== null) {
            return $this->update($current['attachment_id'], $data)
                ? (int) $current['attachment_id']
                : false;
        }

        if (!$this->insert($data)) {
            return false;
        }

        $attachmentId = (int) $this->getInsertID();

        return $attachmentId > 0 ? $attachmentId : false;
    }

    public function removePrimaryImage(string $entityType, int $entityId): bool
    {
        $this->where('entity_type', $entityType)
            ->where('entity_id', $entityId)
            ->where('attachment_type', 'image')
            ->where('is_primary', 1);

        return $this->delete() !== false;
    }
}
