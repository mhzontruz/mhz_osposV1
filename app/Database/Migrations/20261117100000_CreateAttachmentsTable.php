<?php

namespace App\Database\Migrations;

use CodeIgniter\Database\Migration;
use RuntimeException;
use Throwable;

class CreateAttachmentsTable extends Migration
{
    public function up(): void
    {
        $this->forge->addField([
            'attachment_id' => [
                'type'           => 'INT',
                'constraint'     => 10,
                'unsigned'       => true,
                'auto_increment' => true,
            ],
            'entity_type' => [
                'type'       => 'VARCHAR',
                'constraint' => 32,
            ],
            'entity_id' => [
                'type'       => 'INT',
                'constraint' => 10,
                'unsigned'   => true,
            ],
            'attachment_type' => [
                'type'       => 'VARCHAR',
                'constraint' => 32,
                'default'    => 'file',
            ],
            'file_name' => [
                'type'       => 'VARCHAR',
                'constraint' => 255,
            ],
            'mime_type' => [
                'type'       => 'VARCHAR',
                'constraint' => 127,
            ],
            'file_size' => [
                'type'     => 'INT',
                'unsigned' => true,
            ],
            'file_data' => [
                'type' => 'LONGBLOB',
            ],
            'is_primary' => [
                'type'       => 'TINYINT',
                'constraint' => 1,
                'default'    => 0,
            ],
            'created_at' => [
                'type' => 'DATETIME',
                'null' => true,
            ],
            'updated_at' => [
                'type' => 'DATETIME',
                'null' => true,
            ],
        ]);
        $this->forge->addKey('attachment_id', true);
        $this->forge->addKey(['entity_type', 'entity_id', 'attachment_type', 'is_primary']);
        $this->forge->createTable('attachments', true, ['ENGINE' => 'InnoDB', 'DEFAULT CHARSET' => 'utf8mb4']);

        $this->migrateItemImages();
    }

    public function down(): void
    {
        $this->forge->dropTable('attachments', true);
    }

    private function migrateItemImages(): void
    {
        $imageDirectory = FCPATH . 'uploads' . DIRECTORY_SEPARATOR . 'item_pics';

        if (!is_dir($imageDirectory)) {
            return;
        }

        $items = $this->db->table('items')
            ->where('pic_filename IS NOT NULL', null, false)
            ->get()
            ->getResult();

        $this->db->transBegin();

        try {
            foreach ($items as $item) {
                $filename = str_replace(['*', '?', '[', ']'], '', basename((string) $item->pic_filename));

                if ($filename === '' || preg_match('/^db:\d+$/', $filename)) {
                    continue;
                }

                $extension = pathinfo($filename, PATHINFO_EXTENSION);
                $imagePaths = [$imageDirectory . DIRECTORY_SEPARATOR . $filename];
                if ($extension === '') {
                    $imagePaths = glob($imageDirectory . DIRECTORY_SEPARATOR . $filename . '.*');

                    if ($imagePaths === false) {
                        throw new RuntimeException('Unable to find an existing item image during attachment migration.');
                    }
                }

                foreach ($imagePaths as $imagePath) {
                    if (!is_file($imagePath)) {
                        continue;
                    }

                    $imageInfo = getimagesize($imagePath);
                    if ($imageInfo === false || !in_array($imageInfo['mime'], ['image/png', 'image/jpeg', 'image/gif'], true)) {
                        continue;
                    }

                    $fileData = file_get_contents($imagePath);
                    if ($fileData === false) {
                        throw new RuntimeException('Unable to read an existing item image during attachment migration.');
                    }

                    $inserted = $this->db->table('attachments')->insert([
                        'entity_type'     => 'item',
                        'entity_id'       => $item->item_id,
                        'attachment_type' => 'image',
                        'file_name'       => basename($imagePath),
                        'mime_type'       => $imageInfo['mime'],
                        'file_size'       => strlen($fileData),
                        'file_data'       => $fileData,
                        'is_primary'      => 1,
                    ]);

                    if (!$inserted) {
                        throw new RuntimeException('Unable to save an existing item image during attachment migration.');
                    }

                    $attachmentId = $this->db->insertID();
                    if ($attachmentId < 1) {
                        throw new RuntimeException('Unable to identify a saved item image during attachment migration.');
                    }

                    $updated = $this->db->table('items')
                        ->where('item_id', $item->item_id)
                        ->update(['pic_filename' => 'db:' . $attachmentId]);

                    if (!$updated) {
                        throw new RuntimeException('Unable to update an item image reference during attachment migration.');
                    }

                    break;
                }
            }

            if (!$this->db->transStatus()) {
                throw new RuntimeException('Unable to migrate existing item images to attachments.');
            }

            $this->db->transCommit();
        } catch (Throwable $exception) {
            $this->db->transRollback();
            throw $exception;
        }
    }
}
